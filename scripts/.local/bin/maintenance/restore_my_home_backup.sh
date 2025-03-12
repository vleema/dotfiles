#!/bin/bash

# Script para restaurar o backup do home  a partir do link last_home_snapshot
# == Algumas variáveis para facilitar a configuração do script
# Define o que será copiado ("backupeado").
readonly DESTINATION_DIR="${HOME}"
# Define o ponto de montagem do disco de backup
readonly MOUNT_DIR="/mnt/backup"
# Define o diretório de BASE destino dos backups incrementais.
readonly BACKUP_DIR="/mnt/backup/home-selan"
# Define o diretório de backup anterior para base to backup atual.
readonly LATEST_LINK="${BACKUP_DIR}/latest_incremental_backup"


# Define o diretório de origem como o last_system_snapshot
# origem=$(readlink -f /mnt/backup/last_home_snapshot)
readonly SOURCE_DIR=$(readlink -f ${LATEST_LINK})

# Exibe o diretório de origem de onde o backup está sendo restaurado
echo "Recuperando backup a partir do diretório '${SOURCE_DIR}'."

# Verifica se o diretório de origem existe
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Diretório de origem não encontrado. Verifique se o last_home_snapshot está configurado corretamente."
    exit 1
fi

# Pergunta ao usuário se deseja confirmar a restauração
read -p "Tem certeza de que deseja restaurar o home a partir do backup? (S/N): " resposta

# Verifica a resposta do usuário
if [[ $resposta == [Ss]* ]]; then
    # Executa o comando rsync para restaurar o backup
    rsync -aAXv --delete "$SOURCE_DIR/" "$DESTINATION_DIR"
    echo "Restauração concluída com sucesso!"
else
    echo "Restauração cancelada pelo usuário."
fi
