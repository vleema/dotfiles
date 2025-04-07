#!/usr/bin/env bash

prompt="rofi -dmenu -l 7 -i -c -n 3 "

uptime=$(uptime -p | sed -e 's/up //g')

hibernate="   Hibernate"
shutdown="   Shutdown"
reboot="   Reboot"
suspend="  Suspend"
lock="   Lock"
logout="﫼   Logout"
cancel="窱 Cancel"

option="$cancel\n$suspend\n$hibernate\n$shutdown\n$reboot\n$lock\n$logout"

select="$(echo -e "$option" | $prompt -p "Uptime - $uptime" -selected-row 3)"

case $select in
$hibernate)
	run_hibernate
	;;
$shutdown)
	run_shutdown
	;;
$reboot)
	run_reboot
	;;
$suspend)
	run_suspend
	;;
$lock)
	# i3lock
	run_lock
	;;
$logout)
	# hyprctl exit
	run_logout
	;;
esac
