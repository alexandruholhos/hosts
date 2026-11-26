#!/bin/bash


verifica_ip() {
    local host="$1"
    local ip="$2"
    local dns_server="$3"

    local ip_real
    ip_real=$(nslookup "$host" "$dns_server" 2>/dev/null | grep -A1 "Name:" | grep "Address:" | awk '{print $2}' | head -n 1)
    if [ -n "$ip_real" ] && [ "$ip" != "$ip_real" ]; then
        echo "Bogus IP for $host in /etc/hosts!"
    fi
}


cat /etc/hosts | while read -r line; do

    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue


    ip=$(echo "$line" | awk '{print $1}')
    host=$(echo "$line" | awk '{print $2}')


    if [[ "$ip" == "127."* ]] || [[ "$ip" == "::"* ]] || [[ "$ip" == "fe"* ]] || [[ "$ip" == "ff"* ]]; then
        continue
    fi


    ip_real=$(getent ahosts "$host" 2>/dev/null | awk '{print $1}' | head -n 1)


    if [ -n "$ip_real" ] && [ "$ip" != "$ip_real" ]; then
        echo "Bogus IP for $host in /etc/hosts!"
    fi
done
echo "am modificat Matei Ioana"
