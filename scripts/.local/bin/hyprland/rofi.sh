#!/bin/sh

powermenu_type=2
launcher_type=4

ROFI_PATH="$HOME/.config/rofi/"

if [ "$1" = 'p' ]; then
	shift
	exec "$ROFI_PATH"/powermenu/type-$powermenu_type/powermenu.sh "$@"
elif [ "$1" = 'l' ]; then
	shift
	exec "$ROFI_PATH"/launchers/type-$launcher_type/launcher.sh "$@"
fi
