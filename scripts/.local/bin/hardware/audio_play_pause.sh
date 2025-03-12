#!/bin/sh
# ===============================================================
# This script does two distinct tasks:
# 1) It pauses all players that is in Playing status and
# save them to a temporary file so that they can resume
# Playing if the script is called again.
# 2) It resume Playing state if there is a temporary 
# file with a list of players that have been paused
# previously.
# If such list does not exist, the script does nothing.
#
# @author Selan (algorithm) & ChatGPT (bash syntax)
# @date Feb 5th, 2024
# ===============================================================

# Path for the temporary file with the names of active players.
temp_file="/tmp/active_player.txt"

# Check if playerctl is installed
if ! command -v playerctl &> /dev/null; then
    echo "[ERROR in audio_play_pause script]: playerctl is not installed. Please install it and try again."
    exit 1
fi

# Create a list of active players, if there are some.
active_players=$(playerctl -l | awk '{system("playerctl -p " $1 " status | grep Playing >/dev/null && echo " $1)}')

# ====================================================
# Basically we may have two mutually exclusive cases:
#
# [1] There are one or more players active (i.e controllable).
# We determine which ones are Playing, pause them and 
# send their names to an external temporary file so 
# that we can resume the Playing state later on when this
# script is called again.
#
# [2] There is no player active.
# In this case we check if the temporary file exists,
# resuming playing for all of them, OR; we do nothing
# (no file exists).
# ----------------------------------------------------

if [ -z "$active_players" ]; then
    # No active player found, check if the temporary file exists
    if [ -f "$temp_file" ]; then
        # If the temporary file exists, resume playback for all players listed in the file
        while IFS= read -r player; do
            playerctl -p "$player" play
        done < "$temp_file"
    fi
else
    # If there are active players, pause all of them and save their names to the temporary file
    echo "$active_players" > "$temp_file"
    echo "$active_players" | while read -r player; do
        playerctl -p "$player" pause
    done
fi
