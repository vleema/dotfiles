#!/usr/bin/env bash

# Samsung Galaxy Book Performance Profile Switcher
# This script creates a Rofi menu to switch between available performance profiles

# Configure rofi appearance
prompt="rofi -dmenu -l 5 -i -c -n 3 "

# Get current performance profile
current_profile=$(cat /sys/firmware/acpi/platform_profile)

# Get available performance profiles
available_profiles=$(cat /sys/firmware/acpi/platform_profile_choices)

# Create profile options with icons
low_power_option="󰾆  Low Power"
balanced_option="󰾅 Balanced"
performance_option="󰓅  Performance"
quiet_option="󰌪 Quiet"
cancel_option="窱 Cancel"

# Map profile names to display options
create_options() {
	options=""
	for profile in $available_profiles; do
		case $profile in
		"low-power")
			options="$options\n$low_power_option"
			;;
		"balanced")
			options="$options\n$balanced_option"
			;;
		"performance")
			options="$options\n$performance_option"
			;;
		"quiet")
			options="$options\n$quiet_option"
			;;
		esac
	done

	# Add cancel option
	options="$options\n$cancel_option"

	# Remove leading newline if present
	options=$(echo -e "$options" | sed '/^$/d')

	echo "$options"
}

# Determine which option to highlight based on current profile
get_selected_row() {
	row=0
	IFS=$'\n'
	for option in $(create_options); do
		case "$current_profile" in
		"low-power")
			[[ "$option" == "$low_power_option" ]] && echo $row && return
			;;
		"balanced")
			[[ "$option" == "$balanced_option" ]] && echo $row && return
			;;
		"performance")
			[[ "$option" == "$performance_option" ]] && echo $row && return
			;;
		"quiet")
			[[ "$option" == "$quiet_option" ]] && echo $row && return
			;;
		esac
		row=$((row + 1))
	done
	echo 0 # Default to first row if current profile not found
}

# Create the options list
options=$(create_options)

# Get selected row for highlighting current profile
selected_row=$(get_selected_row)

# Display rofi menu and get selection
select="$(echo -e "$options" | $prompt -p "Current Profile: $current_profile" -selected-row $selected_row)"

# Process selection
case $select in
"$low_power_option")
	echo "low-power" | pkexec tee /sys/firmware/acpi/platform_profile >/dev/null
	notify-send "Performance Profile" "Changed to Low Power mode" -i power-profile-power-saver-symbolic
	;;
"$balanced_option")
	echo "balanced" | pkexec tee /sys/firmware/acpi/platform_profile >/dev/null
	notify-send "Performance Profile" "Changed to Balanced mode" -i power-profile-balanced-symbolic
	;;
"$performance_option")
	echo "performance" | pkexec tee /sys/firmware/acpi/platform_profile >/dev/null
	notify-send "Performance Profile" "Changed to Performance mode" -i power-profile-performance-symbolic
	;;
"$quiet_option")
	echo "quiet" | pkexec tee /sys/firmware/acpi/platform_profile >/dev/null
	notify-send "Performance Profile" "Changed to Quiet mode" -i audio-volume-low-symbolic
	;;
"$cancel_option")
	exit 0
	;;
esac
