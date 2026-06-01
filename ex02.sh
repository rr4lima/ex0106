#!/bin/bash


origem="/clinica/dados"
destino="/mnt/hd_externo/backups"
log="/var/log/backup_clinica.log"


data=$(date +%F)


if [ ! -d "$destino" ]; then
    mkdir -p "$destino"
fi


arquivo="$destino/backup_$data.tar.gz"


if tar -czf "$arquivo" "$origem"; then
    status="SUCESSO"
    tamanho=$(du -h "$arquivo" | cut -f1)
else
    status="FALHA"
    tamanho="0"
fi


find "$destino" -name "*.tar.gz" -mtime +30 -delete


echo "$(date '+%Y-%m-%d %H:%M:%S') | Arquivo: $(basename "$arquivo") | Tamanho: $tamanho | Status: $status" >> "$log"


echo "Resumo do Backup"
echo "Data: $(date)"
echo "Arquivo: $(basename "$arquivo")"
echo "Tamanho: $tamanho"
echo "Status: $status"
echo "Destino: $destino"
echo ""
