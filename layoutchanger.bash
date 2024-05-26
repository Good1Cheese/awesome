#!/usr/bin/env bash


# Set current layout to US if Yazi is focused

while true; do
	prev=$window
	window=$(xdotool getwindowfocus getwindowname)

	if [ "$prev" != "$window" ] && [ "$(echo "$window" | awk "/Yazi/")" ]; then
		xkb-switch -s us
	fi

	sleep 0.3
done
