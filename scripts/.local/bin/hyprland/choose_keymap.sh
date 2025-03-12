#!/bin/sh

# A UI for choosing which keymap to apply.

op1="us-intl"
op2="us"
op3="abnt2"

options="$op1\n$op2\n$op3\n"

# Get user choice including multi-monitor and manual selection:
# See ~/.config/hypr/conf/input.conf to understand the numbering 0,1,2 below.
chosen=$(echo -e "$options"  | rofi -dmenu -i -c -l 3 -p "Select keyboard layout:") &&
case "$chosen" in
	$op1) hyprctl switchxkblayout at-translated-set-2-keyboard 0 ;  exit ;;
	$op2) hyprctl switchxkblayout at-translated-set-2-keyboard 1 ;  exit ;;
	$op3) hyprctl switchxkblayout at-translated-set-2-keyboard 2 ;  exit ;;
esac
