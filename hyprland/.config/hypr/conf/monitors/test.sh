# Extrai os nomes dos monitores conectados
get_outputs() {
    hyprctl monitors | awk '/^Monitor / {print $2}' | tr -d '():'
}

manual_selection() {
    local outputs=("$@")

    echo "manual_selection(): Monitors detected:"
    for monitor in "${outputs[@]}"; do
        echo "- $monitor"
    done
}

multi_monitors() {
   local outputs=("$@")
   local num_options=${#outputs[@]}

   if [[ $num_options -eq 2 ]]; then
       echo "2 monitores detectados"
       # Adicione aqui o tratamento para o caso de 2 monitores
   else
       echo "$num_options monitores detectados"
       # Adicione aqui o tratamento para mais de 2 monitores
   fi
}

postrun() {
    # Ajustes pós-configuração
    killall dunst && setsid -f dunst >/dev/null 2>&1
    # notify-send "💻 Configuração de displays concluída."
}

one_screen(){
    echo "entrei em one_screen()"
    hyprctl keyword monitor "$1",preferred,auto,1
}


main() {
    local outputs
    outputs=($(get_outputs))
    echo "main(): Monitors detected:"
    for monitor in "${outputs[@]}"; do
        echo "- $monitor"
    done

    if [[ ${#outputs[@]} -eq 0 ]]; then
        notify-send "Nenhum monitor detectado."
        exit 1
    elif [[ ${#outputs[@]} -eq 1 ]]; then
        # hyprctl keyword monitor "${outputs[0]}",preferred,auto
        postrun
        notify-send "💻 Only one screen detected." "Using it in its optimal settings..."
        exit 0
    fi

    # Monta o menu com os monitores e opções extras
    local options=("${outputs[@]}" "multi-monitor" "manual selection")
    # local num_options=${#options[@]}
    local choice
    choice=$(printf "%s\n" "${options[@]}" | rofi -dmenu -i -p "Select display arrangement:" )
    case "$choice" in
        "") exit 0 ;; # Pressionou ESC
        "manual selection") manual_selection "${outputs[@]}" ;;
        "multi-monitor") multi_monitors "${outputs[@]}" ;;
        *) one_screen "$choice" ;;
    esac

    postrun
}

# Run the main function
main
