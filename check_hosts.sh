#!/bin/bash

cat /etc/hosts | while read -r line; do
    # 1. Sare peste liniile goale si comentariile cu #
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

    # 2. Extrage primul cuvant (IP) si al doilea cuvant (HOST)
    ip=$(echo "$line" | awk '{print $1}')
    host=$(echo "$line" | awk '{print $2}')

    # 3. Sare peste adresele interne/locale (127.*, ::1, fe*, ff*)
    if [[ "$ip" == "127."* ]] || [[ "$ip" == "::"* ]] || [[ "$ip" == "fe"* ]] || [[ "$ip" == "ff"* ]]; then
        continue
    fi

    # 4. Afla IP-ul real din DNS pentru domeniul respectiv
    ip_real=$(getent ahosts "$host" 2>/dev/null | awk '{print $1}' | head -n 1)

    # 5. Afiseaza avertismentul doar daca IP-ul din hosts difera de cel din DNS
    if [ -n "$ip_real" ] && [ "$ip" != "$ip_real" ]; then
        echo "Bogus IP for $host in /etc/hosts!"
    fi
done
