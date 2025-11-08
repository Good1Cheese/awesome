#!/usr/bin/env bash

entries="⏻ Shutdown\n⇠ Lock\n⏾ Suspend\n⭮ Reboot"

selected=$(echo -e "$entries" | bemenu -c -l 5 -W .5 | awk '{print tolower($2)}')

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
lock)
    exec betterlockscreen --lock --blur 30 --dim 10
    ;;
esac
