#!/bin/bash

# Caminho do arquivo temporário para armazenar o histórico
history_file="/tmp/hyprland_workspace_history"
# Leia a última workspace do histórico, se existir
if [ -f "$history_file" ]; then
    last_workspace=$(cat "$history_file")
else
    last_workspace=""
fi

# Obtenha o comando passados como target_workspaceo
command="$1" # Possíveis: workspace ID ou movetoworkspace ID
# Obtenha o (ID da workspace alvo) passada como target_workspaceo
target_workspace="$2"

# Verifique se a workspace alvo é válida (ID <= 10 para workspaces regulares)
if (( target_workspace > 10 )); then
    exit 0
fi

# Obtenha a workspace atual
current_workspace=$(hyprctl activeworkspace | awk '/workspace ID/ {print $3}')

# Caso especial: solicitar mudança pra mesma workspace faz ir para anteior (como em dwm).
# Se a workspace alvo for a mesma que a atual...
if [[ "$target_workspace" == "$current_workspace" ]]; then
    # No caso do comando movetoworkspace nós ignoracmos a solicitação. 
    # Isso porque não faz sentido enviar o cliente para a mesma workspace
    # em que ele já está.
    if [ [ "$command"=="movetoworkspace" ] ]; then
      exit 0
    fi

    # Salve a workspace atual no histórico
    echo "$current_workspace" > "$history_file"

    # Alterne para a última workspace, se for válida e não for especial
    if (( last_workspace <= 10 )); then
        hyprctl dispatch workspace "$last_workspace"
    fi

    exit 0
fi

# Se chegar aqui, é porque a workspace alvo é diferente da atual.

# Atualize o histórico
echo "$current_workspace" > "$history_file"

# Mude para a workspace alvo
hyprctl dispatch "$command" "$target_workspace"
