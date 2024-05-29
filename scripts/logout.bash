#!/usr/bin/env bash

# Load dmenu config
# shellcheck source=/dev/null
[ -f "$HOME/.dmenurc" ] && . "$HOME/.dmenurc" || DMENU='dmenu -i'

# Menu items
items="sus
reb
relo
pow"

# Open menu
selection=$(printf '%s' "$items" | $DMENU)

case $selection in
	relo)
		awesome-client 'awesome.restart()'
		;;
	reb)
		reboot
		;;
	sus)
		systemctl suspend
		;;
	pow)
		sudo shutdown now
		;;
esac

exit
