#!/usr/bin/env bash

entries="⏻ Shutdown\n⏾ Suspend\n⭮ Reboot\n⇠ Logout"

selected=$(echo -e $entries | bemenu -c -l 4 -W .4 | awk '{print tolower($2)}')

case $selected in
logout)
	swaymsg exit
	;;
suspend)
	exec systemctl suspend
	;;
reboot)
	exec systemctl reboot
	;;
shutdown)
	exec systemctl poweroff -i
	;;
esac
