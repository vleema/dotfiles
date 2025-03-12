#!/bin/sh

# Check if playerctl is installed
if ! command -v playerctl &> /dev/null; then
    #echo "playerctl is not installed. Please install it and try again."
    exit 1
fi

# Create a list of active players, if there are some.
active_players=$(playerctl -l | awk '{system("playerctl -p " $1 " status | grep Playing >/dev/null && echo " $1)}')

# Loop through each player to find the active one
echo "$active_players" | while read -r player; do
    playerctl -p "$player" previous
done
