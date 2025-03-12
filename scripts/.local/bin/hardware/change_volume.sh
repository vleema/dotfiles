#!/bin/bash

# Arbitrary but unique message tag
msgTag="myvolume"

function send_notification() {
	# Obtém o volume e converte para porcentagem com awk
	volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
	# dunstify -a "Change volume" -u low -r 9994 -h int:value:"$volume" -i "volume-$1" "Volume: ${volume}%" -t 2000
    dunstify -a "changeVolume" -u low -i audio-volume-high -h string:x-dunst-stack-tag:$msgTag \
    -h int:value:"$volume" "Volume: ${volume}%"
}

case $1 in
up)
	# Aumenta o volume em 2%
	wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+
	send_notification $1
	;;
down)
	# Diminui o volume em 2%
	wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-
	send_notification $1
	;;
mute)
	# Alterna mute
	wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
	# Verifica o estado do mute
	mute_status=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -oP '(MUTED|[^\s]+$)' | tail -n1)
	if [ "$mute_status" = "[MUTED]" ]; then
		# dunstify -i volume-mute -a "Change volume" -t 2000 -r 9993 -u low "Muted"
    # Show the sound muted notification
    dunstify -a "changeVolume" -u low -i audio-volume-muted -h string:x-dunst-stack-tag:$msgTag "Volume muted"
	else
		send_notification $1
	fi
	;;
esac
