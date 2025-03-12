#!/bin/bash
#Declare colors
red='\033[0;31m'
nc='\033[0m'
yellow='\033[1;33m'

# xdo hide -N KeePassXC
# xdo show -N KeePassXC

term_cmd="kitty --detach --override initial_window_width=144c -o initial_window_height=34c --class "
keepass_cmd="keepassxc $HOME/Documents/System_Information/Keepassxc_db/Passwords.kdbx"
scratch () {
    case $1 in
        pad)
            winclass="$(is_running.sh sp_term)"
            if [ -z "$winclass" ]; then
                $term_cmd sp_term 2> /dev/null
            else
               hyprctl dispatch togglespecialworkspace sp_term
            fi
            ;;
        keepass)
            winclass="$(is_running.sh org.keepassxc.KeePassXC)"
            if [ -z "$winclass" ]; then
                $keepass_cmd & 2> /dev/null
            else
               hyprctl dispatch togglespecialworkspace keepassxc
            fi
            ;;
        pulse)
            winclass="$(is_running.sh sp_pulse)"
            if [ -z "$winclass" ]; then
                $term_cmd sp_pulse -e pulsemixer 2> /dev/null
            else
               hyprctl dispatch togglespecialworkspace sp_pulse
            fi
            ;;
        music)
            winclass="$(is_running.sh sp_music)"
            if [ -z "$winclass" ]; then
                $term_cmd sp_music -e ncmpcpp 2> /dev/null
            else
               hyprctl dispatch togglespecialworkspace sp_music
            fi
            ;;
        btop)
            winclass="$(is_running.sh sp_btop)"
            if [ -z "$winclass" ]; then
                $term_cmd sp_btop -e btop 2> /dev/null
            else
               hyprctl dispatch togglespecialworkspace sp_btop
            fi
            ;;
        yazi)
            winclass="$(is_running.sh sp_yazi)"
            if [ -z "$winclass" ]; then
                $term_cmd sp_yazi -e yazi 2> /dev/null
            else
               hyprctl dispatch togglespecialworkspace sp_yazi
            fi
            ;;
        fzf)
            winclass="$(is_running.sh sp_fzf)"
            if [ -z "$winclass" ]; then
                $term_cmd sp_fzf -e fzf-launcher.sh 2> /dev/null
            else
               hyprctl dispatch togglespecialworkspace sp_fzf
            fi
            ;;
        *)
            printf ${red}">>> Invalid argument! ${nc} $1 \n"
            printf ${yellow}">>> Valid arguments are:\n"
            printf "      btop\n"
            printf "      fzf\n"
            printf "      keepass\n"
            printf "      music\n"
            printf "      pad\n"
            printf "      pulse\n"
            printf "      yazi ${nc}\n" && exit 1
            ;;

    esac
}

scratch $1
