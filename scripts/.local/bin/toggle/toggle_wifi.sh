#!/bin/sh

# Toggle on/off wifi
service_status=$(nmcli radio wifi)
if [[ "$service_status" == "enabled" ]]; then
    notify-send "Turning OFF wifi."
    nmcli radio all off
else
    notify-send  "Turning ON wifi."
    nmcli radio all on
fi
