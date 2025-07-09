#!/bin/bash

CONFIG="$HOME/.config/hypr/conf/keybindings.conf"

QWERTY="source = ~/.config/hypr/conf/keybindings/qwerty.conf"
COLEMAK="# source = ~/.config/hypr/conf/keybindings/colemak_dh.conf"
QWERTY_COMMENTED="# source = ~/.config/hypr/conf/keybindings/qwerty.conf"
COLEMAK_UNCOMMENTED="source = ~/.config/hypr/conf/keybindings/colemak_dh.conf"

if grep -q "^$QWERTY" "$CONFIG"; then
  # Switch to Colemak
  sed -i "s|^$QWERTY|$QWERTY_COMMENTED|" "$CONFIG"
  sed -i "s|^$COLEMAK|$COLEMAK_UNCOMMENTED|" "$CONFIG"
  notify-send "Switched to Colemak DH"
elif grep -q "^$COLEMAK_UNCOMMENTED" "$CONFIG"; then
  # Switch to QWERTY
  sed -i "s|^$COLEMAK_UNCOMMENTED|$COLEMAK|" "$CONFIG"
  sed -i "s|^$QWERTY_COMMENTED|$QWERTY|" "$CONFIG"
  notify-send "Switched to QWERTY"
else
  notify-send "Could not determine the current keyboard layout"
  exit 1
fi
