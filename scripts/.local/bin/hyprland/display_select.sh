#!/bin/bash

# Extrai os nomes dos monitores conectados
get_outputs() {
    hyprctl monitors | awk '/^Monitor / {print $2}' | tr -d '():'
}

# Dispatcher for 2 possible common situations
multi_monitors() { # Multi-monitor handler.
   local outputs=("$@")
   local num_options=${#outputs[@]}

   if [[ $num_options -eq 2 ]]; then
       echo "2 monitores detectados"
       # Adicione aqui o tratamento para o caso de 2 monitores
       two_screens "${outputs[@]}"
   else
       echo "$num_options monitores detectados"
       # Adicione aqui o tratamento para mais de 2 monitores
       three_screens  "${outputs[@]}"
   fi
}

# Handles two monitors as mirroed or independent from one another.
two_screens() {
    local outputs=("$@")
    local mirror internal external primary secondary direction

    # Mirror displays using native resolution of external display and a scaled
    # version for the internal display
    mirror=$(printf "no\nyes" | rofi -dmenu -i -p "Mirror displays?")
    if [ "$mirror" = "yes" ]; then
        internal=$(printf "%s\n" "${outputs[@]}" | rofi -dmenu -i -p "Optimize resolution for:")
        external=$(printf "%s\n" "${outputs[@]}" | grep -v "$internal")

        hyprctl keyword monitor "$internal",preferred,auto, 1
        hyprctl keyword monitor "$external",preferred,auto, 1, mirror, "$internal"
    else
        primary=$(printf "%s\n" "${outputs[@]}" | rofi -dmenu -i -p "Select the primary display:")
        secondary=$(printf "%s\n" "${outputs[@]}" | grep -v "$primary")
        direction=$(printf "left\nright\ntop\nbottom" | rofi -dmenu -i -p "Position $secondary in relation to $primary:")

        hyprctl keyword monitor "$primary"  , preferred, auto,              1
        hyprctl keyword monitor "$secondary", preferred, auto-"$direction", 1
    fi
}

three_screens(){
    local outputs=("$@")
    local mirror external internal primary secondary side opposite_side

    primary=$(echo "$screens" | rofi -dmenu -i -p "Select primary display:")
    secondary=$(echo "$screens" | grep -v "$primary" | rofi -dmenu -i -p "Select secondary display:")
    side=$(printf "left\nright" | rofi -dmenu -i -p "What side of $primary should $secondary be on?")
    tertiary=$(echo "$screens" | grep -v "$primary" | grep -v "$secondary" | rofi -dmenu -i -p "Select third display:")
    opposite_side=$(printf "left\nright" | grep -v "$side")

    hyprctl keyword monitor "$primary"  ,preferred, auto
    hyprctl keyword monitor "$secondary",preferred, auto-"$side", auto
    hyprctl keyword monitor "$tertiary" ,preferred, auto-"$opposite_side $primary"
}

manual_selection() {
    notify-send "Opening Hyprland monitor config" "Symlink your res choice to default.conf"
    $TERMINAL -e ~/.config/hypr/conf/monitors/
}

postrun() {
    # Ajustes pós-configuração
    killall dunst && setsid -f dunst >/dev/null 2>&1
    # notify-send "💻 Configuração de displays concluída."
}

one_screen(){
    # echo "entrei em one_screen()"
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
        hyprctl keyword monitor "${outputs[0]}",preferred,auto,1
        # postrun
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

main

