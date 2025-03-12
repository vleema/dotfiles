#!/bin/sh

if pgrep -x "dunst" > /dev/null
then
    is_paused=`dunstctl is-paused`
    if [ $is_paused = "true" ] ; then
        dunstctl set-paused false
        (notify-send "Turning ON notifications.")
    else
        (notify-send "Turning OFF notifications.")
        sleep 2 # We need to wait so that the previous notification is properly "consumed"
        # Otherwise, this message will appear **again** when the notifications is turned back on.
        dunstctl set-paused true
    fi
fi
