#!/bin/sh
# Nome do processo do hypridle
process_name="hypridle"
icon_suspended="&#xed1e;"   # Ícone para quando o hypridle estiver suspenso
icon_active=""        # Nenhum ícone quando o hypridle estiver ativo

# Verifique se o processo está em execução
if pgrep -x "$process_name" > /dev/null; then
    echo "$icon_active"  # Retorna uma string vazia para indicar que está ativo
else
    echo "$icon_suspended"  # Retorna o ícone para quando o hypridle está suspenso
fi
