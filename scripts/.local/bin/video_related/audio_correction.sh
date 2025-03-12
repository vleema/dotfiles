#!/bin/sh

# This script fixes the audio delay issue that happens when I capture the
# webcam as parte of a screencast recording.
# Usually the audio of the webcam is out of sysn with the webcam image.

base=$(basename "$1")
ext="${base##*.}"
base="${base%.*}"

ffmpeg -i "$1" -itsoffset 0.350 -i "$1" -c:v copy -c:a copy -map 0:0 -map 1:1 "$base"_synced."$ext" &&
    notify-send "Fixaudio script." "Done."
