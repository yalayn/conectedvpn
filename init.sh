#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

CONFIG="/home/yordin/Projects/conectedvpn/config.ini"

read_conf() {
    local SECTION="$1"
    local KEY="$2"
    local FILE="$3"
    sed -n '/^\['$SECTION'\]/,/^\[.*\]/p' "$FILE" | awk -F "=" '/^\s*'"$KEY"'\s*/ {gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2; exit}'
}

IP_PING=$(read_conf "MAIN" "ip_verification" "$CONFIG")
PATH_CONECTED=$(read_conf "MAIN" "path_conected" "$CONFIG")

echo "Verifica coneccion VPN"
IP_RESPONSE=$(ping -q -c 1 $IP_PING)
RESPONSE_CONECTED="received, 100%"
if [[ "$IP_RESPONSE" == *"$RESPONSE_CONECTED"* ]]; then
    echo "No conectado ejecutando script."
    sh "$PATH_CONECTED/conected.sh"
else 
    echo "Conectado. Nada que hacer"
fi


