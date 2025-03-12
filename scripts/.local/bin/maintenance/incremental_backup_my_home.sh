#!/bin/bash

# =============================================================================
# Script atualizado em 21/12/2023 para realizar um backup
# incremental do meu home.
# IMPORTANTE: o backup incremental é feito com base em
# um backup anterior de referência. No caso, vou usar como 
# referência o link simbólico last_home_snapshot.
#
# SOURCE: https://linuxconfig.org/how-to-create-incremental-backups-using-rsync-on-linux
# =============================================================================

# =============================================================================
# [1] PREPARAÇÃO da OPERAÇÃO de BACKUP
# -----------------------------------------------------------------------------
# Definir comportamento de erros mais robustos

# Esse comando faz com que o script seja encerrado imediatamente se algum comando 
# retornar um status de saída diferente de zero (indicando um erro). Ou seja, se 
# qualquer comando falhar, o script será interrompido.
# Isso é útil para evitar que o script continue executando mesmo quando ocorre um erro,
# ajudando a identificar e lidar com problemas rapidamente.
set -o errexit

# Com essa configuração, o script será encerrado se tentar usar uma variável não 
# definida (nula). Se alguma variável não tiver sido atribuída com um valor, o
# script será interrompido.
# Isso ajuda a evitar erros comuns ao usar variáveis que não foram inicializadas,
# o que pode levar a resultados inesperados.
set -o nounset

# Essa configuração faz com que o status de saída de um pipeline (sequência de 
# comandos conectados por pipes |) seja determinado pelo status de saída do 
# comando que falhar por último dentro do pipeline.
# Normalmente, o status de saída de um pipeline é o status de saída do último 
# comando. Com pipefail, se qualquer comando dentro do pipeline falhar, o 
# status de saída do pipeline será o status de saída desse comando. Isso 
# pode ser útil para identificar onde ocorreu um erro em pipelines complexos.
set -o pipefail

# == Algumas variáveis para facilitar a configuração do script
# Define o que será copiado ("backupeado").
readonly SOURCE_DIR="${HOME}"
# Define o ponto de montagem do disco de backup
readonly MOUNT_DIR="/mnt/backup"
# Define o diretório de BASE destino dos backups incrementais.
readonly BACKUP_DIR="/mnt/backup/home-selan"
# Define um nome da subpasta que receberá o backup atual com base na data-horário.
readonly DATETIME="$(date '+%Y-%m-%d_%H:%M:%S')"
# Define onde salvar o backup.
readonly BACKUP_PATH="${BACKUP_DIR}/${DATETIME}"
# Define o diretório de backup anterior para base to backup atual.
readonly LATEST_LINK="${BACKUP_DIR}/latest_incremental_backup"
# Define o número de backups antigos a serem preservados.
readonly MAX_BACKUPS=6

# Verifica se o disco de backup está montado
if ! mountpoint -q "$MOUNT_DIR"; then
    echo "O diretório de destino '$MOUNT_DIR' não está montado."
    echo "Por favor, monte o diretório antes de prosseguir."
    exit 1
fi
# Criar a subpasta, caso não exista ainda.
mkdir -p "${BACKUP_DIR}"

# =============================================================================
# [2] EXECUTAR NOVO BACKUP
# -----------------------------------------------------------------------------
# Executa o comando rsync para realizar o backup
echo "Iniciando backup em '$BACKUP_DIR'."
rsync -aAXv --delete \
    "${SOURCE_DIR}/" \
    --link-dest "${LATEST_LINK}" \
    --exclude={".cache/*",".ssh/*",".local/share/Trash/*",".mozilla/*","Downloads/*"} \
    "${BACKUP_PATH}"

# Remove o link existente
\rm -rf "${LATEST_LINK}"

# Cria um novo link simbólico para o último backup
\ln -sf "${BACKUP_PATH}" "${LATEST_LINK}"


# # =============================================================================
# # [3] REMOVER BACKUP ANTIGO
# # -----------------------------------------------------------------------------
# # Verifica se o número de backups existentes é maior do que `MAX_BACKUPS`
# # Se for, apagamos os backups mais antigos.
# BACKUP_COUNT=$(find "${BACKUP_DIR}" -mindepth 1 -maxdepth 1 -type d | wc -l)
# echo "Backup count is: '${BACKUP_COUNT}'."
#
# while [[ ${BACKUP_COUNT} -gt ${MAX_BACKUPS} ]]; do
#     # Obtém o backup mais antigo e o remove
#     BACKUP_ANTIGO=$(find "${BACKUP_DIR}" -mindepth 1 -maxdepth 1 -type d | sort | head -n 1)
#     echo "Removendo diretório de backup antigo: '${BACKUP_ANTIGO}'."
#     \rm -rf "${BACKUP_ANTIGO}"
#
#     # Atualiza a contagem de backups
#     BACKUP_COUNT=$(find "${BACKUP_DIR}" -mindepth 1 -maxdepth 1 -type d | wc -l)
# done
