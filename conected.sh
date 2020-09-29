#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

CONFIG="/home/yordin/Projects/conectedvpn/config.ini"

read_conf() {
    local SECTION="$1"
    local KEY="$2"
    local FILE="$3"
    sed -n '/^\['$SECTION'\]/,/^\[.*\]/p' "$FILE" | awk -F "=" '/^\s*'"$KEY"'\s*/ {gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2; exit}'
}

VPN_HOST=$(read_conf "VPN" "host" "$CONFIG")
VPN_USER=$(read_conf "VPN" "user" "$CONFIG")
VPN_PASS=$(read_conf "VPN" "pass" "$CONFIG")
PATH_FORTICLIENT=$(read_conf "VPN" "path_forticlient" "$CONFIG")
PATH_SCRIPT_TMP=$(read_conf "VPN" "path_script_tmp" "$CONFIG")

cat << EOF > $PATH_SCRIPT_TMP
#!/usr/bin/expect -f
set timeout -1
cd $PATH_FORTICLIENT
spawn ./forticlientsslvpn_cli connect --server $VPN_HOST --vpnuser $VPN_USER --keepalive
expect "Password for VPN:" {send -- "$VPN_PASS\r"}
expect "to this server? (Y/N)\r" {send -- "y\r"}
expect eof
EOF

expect $PATH_SCRIPT_TMP
