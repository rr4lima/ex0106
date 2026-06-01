#!/bin/bash

ontem=$(date -d "yesterday" +%F)

log-="/var/log/webserver/$ontem.log"
relatorio="/relatorios/log_$ontem.txt"

mkdir -p /relatorios

echo "RELATÓRIO DE LOGS" > "$relatorio"
echo "Data: $(date)" >> "$relatorio"
echo "" >> "$relatorio"

total=$(wc -l < "$log")

HTTP200=$(grep " | 200 | " "$log" | wc -l)
HTTP404=$(grep " | 404 | " "$log" | wc -l)
HTTP500=$(grep " | 500 | " "$log" | wc -l)

echo "Total de requisições: $total" >> "$relatorio"
echo "200: $HTTP200" >> "$relatorio"
echo "404: $HTTP404" >> "$relatorio"
echo "500: $HTTP500" >> "$relatorio"

echo "" >> "$relatorio"
echo "TOP 5 ERROS 404" >> "$relatorio"

grep " | 404 | " "$log" |
awk -F'|' '{print $3}' |
sort |
uniq -c |
sort -nr |
head -5 >> "$relatorio"

echo "" >> "$relatorio"
echo "Requisições acima de 2 segundos" >> "$relatorio"

awk -F'|' '
{
tempo=$4
gsub("s","",tempo)

if(tempo>2)
print $0
}
' "$log" >> "$relatorio"

if [ "$HTTP500" -gt 10 ]
then
    echo "ALERTA: Mais de 10 erros 500 encontrados!"
fi
