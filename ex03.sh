#!/bin/bash

arquivo="alunos.csv"
relatorio="relatorio_cadastro.txt"

total=0
falhas=0

echo "Relatório de Cadastro" > "$relatorio"
echo "=====================" >> "$relatorio"
echo "" >> "$relatorio"

tail -n +2 "$arquivo" | while IFS=',' read -r NOME CPF TURMA EMAIL
do
    usuario=$(echo "$nome" | tr '[:upper:]' '[:lower:]' | tr ' ' '.')

    mkdir -p "/turmas/$turma"

    senha=$(echo "$cpf" | tr -d '.-')

    if id "$usuario" &>/dev/null
    then
        echo "[ERRO] Usuário $usuario já existe" >> "$relatorio"
        ((FALHAS++))
    else
        useradd -m "$usuario"

        echo "$usuario:$senha" | chpasswd

        usermod -aG "$tema" "$usuario" 2>/dev/null

        echo "$usuario ($turma)" >> "$relatorio"

        ((TOTAL++))
    fi
done

echo "" >> "$relatorio"
echo "Total criados: $total" >> "$relatorio"
echo "Falhas: $falhas" >> "$relatorio"
