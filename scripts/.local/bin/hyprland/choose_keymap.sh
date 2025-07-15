#!/bin/sh

# A UI for choosing which keymap to apply.

op1="us-intl"
op2="us"
op3="abnt2"
op4="colemak"

options="$op1\n$op2\n$op3\n$op4\n"

# Get user choice including multi-monitor and manual selection:
# See ~/.config/hypr/conf/input.conf to understand the numbering 0,1,2,3 below.
chosen=$(echo -e "$options" | rofi -dmenu -i -c -l 4 -p "Select keyboard layout:") &&
  case "$chosen" in
  $op1)
    hyprctl switchxkblayout current 0
    exit
    ;;
  $op2)
    hyprctl switchxkblayout current 1
    exit
    ;;
  $op3)
    hyprctl switchxkblayout current 2
    exit
    ;;
  $op4)
    hyprctl switchxkblayout current 3
    exit
    ;;
  esac
