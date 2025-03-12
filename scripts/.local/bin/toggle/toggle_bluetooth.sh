#!/bin/sh
if [ $(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]
then
  notify-send "Turning ON bluetooth."
  bluetoothctl power on
else
  notify-send "Turning OFF bluetooth."
  bluetoothctl power off
fi
