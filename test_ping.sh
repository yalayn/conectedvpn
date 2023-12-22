#!/bin/bash

# Función para realizar el ping y verificar la conexión
check_connection() {
    echo "Ingrese la dirección IP que desea verificar:"
    read ip_address

    # Realizar el ping
    ping -c 4 $ip_address > /dev/null 2>&1

    # Verificar el código de salida del comando ping
    if [ $? -eq 0 ]; then
        echo "¡Conexión exitosa! La IP $ip_address responde al ping."
    else
        echo "No hay conexión. La IP $ip_address no responde al ping."
    fi
}

# Llamar a la función
check_connection