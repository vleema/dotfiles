#!/usr/bin/env bash

# If an instance of wf-recorder is running under this user kill it with SIGINT and exit
if pkill --euid "$USER" --signal SIGINT wf-recorder; then
    notify-send "Screen Recording" "Recording successfuly stopped."
    exit
fi

# Definir um valor padrão para o timeout (em segundos)
default_timeout=600

# Permitir que o usuário passe um tempo de timeout como argumento
timeout_duration="${1:-$default_timeout}" # Usa o valor do argumento ou o padrão

# Define paths
DefaultSaveDir=$HOME'/Videos/Recordings/'
# Check if the directory exists, if not, create it
if [[ ! -d "$DefaultSaveDir" ]]; then
    mkdir -p "$DefaultSaveDir"
fi

TmpPathPrefix='/tmp/mp4-record'
TmpRecordPath=$TmpPathPrefix'-cap.mp4'
TmpPalettePath=$TmpPathPrefix'-palette.png'

# Trap for cleanup on exit
OnExit() {
	[[ -f $TmpRecordPath ]] && rm -f "$TmpRecordPath"
	[[ -f $TmpPalettePath ]] && rm -f "$TmpPalettePath"
}
trap OnExit EXIT

# Set umask so tmp files are only acessible to the user
umask 177

# Get selection and honor escape key
Coords=$(slurp) || exit

# Envia notificação de início da gravação
notify-send "Screen Recording" "Recording started, press (Mod+o)+r to stop it."

# Capture video using slup for screen area
# timeout and exit after 10 minutes as user has almost certainly forgotten it's running
if [[ "$timeout_duration" -gt 0 ]]; then
    timeout "$timeout_duration" wf-recorder -g "$Coords" -a -f "$TmpRecordPath" || exit
else
    wf-recorder -g "$Coords" -a -f "$TmpRecordPath" || exit
fi

# Get the filename from the user and honor cancel
SavePath=$( zenity \
	--file-selection \
	--save \
	--confirm-overwrite \
	--file-filter=*.mp4 \
	--filename="$DefaultSaveDir""/rec_$(date +%Y%m%d_%H%M%S).mp4" \
) || exit

# Copy the file from the temporary path to the save path
cp $TmpRecordPath $SavePath

# copy the file location to your clipboard
wl-copy $SavePath

# Append .gif to the SavePath if it's missing
#[[ $SavePath =~ \.gif$ ]] || SavePath+='.gif'

# Produce a pallete from the video file
#ffmpeg -i "$TmpRecordPath" -filter_complex "palettegen=stats_mode=full" "$TmpPalettePath" -y || exit

# Return umask to default
umask 022

# Use pallete to produce a gif from the video file
# ffmpeg -i "$TmpRecordPath" -i "$TmpPalettePath" -filter_complex "paletteuse=dither=sierra2_4a" "$SavePath" -y || exit
