#!/usr/bin/env bash

# =====================================================================================================
# Activate the webcam available.
# This is useful to make videos where I appear on a small windows somewhere in the desktop.
# This script is associated with the CMD+F4 inside dwm.
#
# =====================================================================================================
# NOTE: TO AVOID >>FLICKERING<<, TURN OFF THE COMPOSITOR (picom, compton, etc.)
#       DURING CAPTURE.
# =====================================================================================================

if [ "$1" != "" ]; then
    DEVICE="/dev/video$1"
else
    DEVICE=$(ls /dev/video[0,1,2,3,4,5,6,7,8] | tail -n 1)
fi

mpv --untimed \
    --no-cache \
    --no-osc \
    --no-input-default-bindings \
    --profile=low-latency \
    --input-conf=/dev/null \
    --title=webcam "$DEVICE"
