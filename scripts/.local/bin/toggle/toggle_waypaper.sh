#!/bin/sh

if pgrep -x "waypaper" > /dev/null
then
    killall waypaper &> /dev/null
else
    waypaper &
fi
