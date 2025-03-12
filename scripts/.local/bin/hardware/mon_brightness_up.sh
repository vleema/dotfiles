#!/bin/sh

# Author: Selan
# Date: October 12th, 2021

# Alternative command. Using `brightnessctl` tough, because it's the same for the keyboard backlight control
# xbacklight -inc 5


# ------------------
# From the man page:
# ------------------
# brightnessctl set 50%-
#   Subtracts 50% of the maximum from the current brightness.
#
# brightnessctl set +10%
#   Adds 10% of the maximum to the current brightness.
brightnessctl --device='intel_backlight' set +1%
