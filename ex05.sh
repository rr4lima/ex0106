#!/bin/bash

log="/var/log/monitor_servidor.log"

data=$(date "+%Y-%m-%d %H:%M:%S")

cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'.' -f1)

ram=$(free -m | awk '
nr==2 {
printf("%.0f", $3*100/$2)
}')

disco=$(df -h / | awk '
NR==2 {
gsub("%","")
print $5
}')

status="okK]"

if [ "$cpu" -gt 80 ] || [ "$ram" -gt 85 ] || [ "$disco" -gt 90 ]
then
    status="[alerta]"
fi

processos="sshd nginx"

proc_status=""

for proc in $processos
do
    if pgrep "$proc" >/dev/null
    then
        proc_status="$proc:ok "
    else
        proc_status="$proc:falha "
        status="[alerta]"
    fi
done

echo "$data $status cpu=${cpu}% ram=${ram}% disco=${disco}% $proc_status" >> "$log"
