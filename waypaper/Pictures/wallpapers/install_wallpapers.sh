#!/bin/sh
# Copia imagens de folder wallpaper para $HOME/Pictures/walpapers/

mkdir -p $HOME/Pictures/wallpapers/
cp $HOME/arch_install/wallpapers/* $HOME/Pictures/wallpapers/
ln -sf $HOME/Pictures/wallpapers/dark_hills.jpg $HOME/.local/share/bg
