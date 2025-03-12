#!/bin/bash

# Verifica se foi fornecido o argumento
if [ -z "$1" ]; then
  echo "Uso: $0 <nome_da_classe>"
  exit 1
fi

# Argumento com o nome da classe da aplicação
app_class="$1"

# Obtém as informações das janelas em execução no Hyprland
windows_info=$(hyprctl clients)

# Procura o campo Window correspondente ao nome da classe fornecida
window_id=$(echo "$windows_info" | awk -v class="$app_class" '
  $0 ~ /^Window/ { id = $2 } 
  $0 ~ "class: " class { print id; exit }
')

# Se encontrou, imprime o ID da janela, caso contrário, imprime vazio
if [ -n "$window_id" ]; then
  echo "$window_id"
else
  echo ""
fi
