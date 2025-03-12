#!/bin/sh

if pgrep -x "waybar" > /dev/null
then
    # notify-send "Killing waybar..."
    killall waybar &> /dev/null
else
    # notify-send -u "Starting waybar."
    waybar &
fi
