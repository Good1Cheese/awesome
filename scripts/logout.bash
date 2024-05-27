#!/usr/bin/env bash

# Load dmenu config
# shellcheck source=/dev/null
[ -f "$HOME/.dmenurc" ] && . "$HOME/.dmenurc" || DMENU='dmenu -i'

# Menu items
items="suspend
reboot
poweroff"

# Open menu
selection=$(printf '%s' "$items" | $DMENU)

case $selection in
	restart)
		restart
		;;
	suspend)
		systemctl suspend
		;;
	reboot)
		reboot
		;;
	halt|poweroff|shutdown)
		sudo shutdown now
		;;
esac

exit
