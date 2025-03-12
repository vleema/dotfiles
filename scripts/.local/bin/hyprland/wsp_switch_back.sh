#!/bin/bash

# Caminho do arquivo temporário para armazenar o histórico
history_file="/tmp/hyprland_workspace_history"

# Obtenha o ID da workspace atual
current_workspace=$(hyprctl activeworkspace | awk '/workspace ID/ {print $3}')

# Verifique se o ID da workspace é maior que 10 (workspace especial)
if (( current_workspace > 10 )); then
    exit 0
fi

# Leia a última workspace do histórico, se existir
if [ -f "$history_file" ]; then
    last_workspace=$(cat "$history_file")
else
    last_workspace=""
fi

# Salve a workspace atual no histórico
echo "$current_workspace" > "$history_file"

# Alterne para a última workspace, se for válida e não for especial
if [[ -n "$last_workspace" && "$last_workspace" != "$current_workspace" ]]; then
    if (( last_workspace <= 10 )); then
        hyprctl dispatch workspace "$last_workspace"
    fi
fi
