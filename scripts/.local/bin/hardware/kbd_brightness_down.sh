#!/bin/sh

# Author: Selan
# Date: October 12th, 2021

# ------------------
# From the man page:
# ------------------
# brightnessctl set 50%-
#   Subtracts 50% of the maximum from the current brightness.
#
# brightnessctl set +10%
#   Adds 10% of the maximum to the current brightness.
brightnessctl -q --device='smc::kbd_backlight' set 1%-
