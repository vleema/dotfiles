#!/bin/sh
# Nome do processo do hypridle
process_name="hypridle"

# Verifique se o processo está em execução
if pgrep -x "$process_name" > /dev/null; then
    # Processo em execução, então mate-o para desativar
    pkill -x "$process_name"
    notify-send "Turning OFF lock screen when idle."
else
    # Processo não está em execução, então reinicie-o
    hypridle &
    notify-send "Turning ON lock screen when idle."
fi
