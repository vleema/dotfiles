#!/bin/bash

# Caminho do arquivo temporário para armazenar o histórico
history_file="/tmp/hyprland_workspace_history"

# Obtenha o comando e o deslocamento passados como argumentos
command="$1" # Possíveis comandos: workspace or movetoworkspace
offset="$2"  # Deslocamentos: e+1 ou e-1

# Obtenha o ID da workspace atual
current_workspace=$(hyprctl activeworkspace | awk '/workspace ID/ {print $3}')

# Execute o deslocamento relativo
hyprctl dispatch "$command" "$offset"

# Aguarde um breve momento para a mudança de workspace ser concluída
sleep 0.1

# Obtenha a nova workspace atual
new_workspace=$(hyprctl activeworkspace | awk '/workspace ID/ {print $3}')

# Se a nova workspace for diferente da atual, atualize o histórico
if [[ "$new_workspace" != "$current_workspace" ]]; then
    echo "$current_workspace" > "$history_file"
fi
