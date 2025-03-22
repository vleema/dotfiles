#!/bin/bash
while true; do
	bat_lvl=$(cat /sys/class/power_supply/BAT1/capacity)
	bat_status=$(cat /sys/class/power_supply/BAT1/status)

	if [ "$bat_lvl" -le 15 ] && [ "$bat_status" != "Charging" ]; then
		notify-send --urgency=CRITICAL "Battery Low! Put a charger on" "Level: ${bat_lvl}%"
		sleep 1200
	else
		sleep 120
	fi
done
