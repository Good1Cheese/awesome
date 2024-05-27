#!/usr/bin/env bash

# Load dmenu config
# shellcheck source=/dev/null
[ -f "$HOME/.dmenurc" ] && . "$HOME/.dmenurc" || DMENU='dmenu -i'

# Menu items
items="suspend
reboot
reloadWM
poweroff"

# Open menu
selection=$(printf '%s' "$items" | $DMENU)

case $selection in
	reloadWM)
		awesome-client 'awesome.restart()'
		;;
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
