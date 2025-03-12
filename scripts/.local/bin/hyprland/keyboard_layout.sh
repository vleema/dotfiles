#!/bin/sh

# Verifica o layout atual do teclado
layout=$(setxkbmap -query | grep layout | awk '{print $2}')
variant=$(setxkbmap -query | grep variant | awk '{print $2}')

keyboard_icon="󰌓"
keyboard_value=""

# Verifica se o layout é US sem nenhuma variante
if [ "$layout" == "us" ] && [ -z "$variant" ]; then
    keyboard_value="US"
elif [ "$layout" == "br" ]; then
    keyboard_value="BR"
fi

case "$1" in
    icon)
        printf "%s\n" $keyboard_icon
        ;;
    value)
        printf "%s\n" $keyboard_value
        ;;
    *)
        if [ "$keyboard_value" == "" ]; then
          exit 0
        fi
        printf "%s %s\n" $keyboard_icon $keyboard_value
        ;;
esac
