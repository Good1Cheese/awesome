#!/usr/bin/env bash

# if [ -f ~/awesome-startup ]; then
#     exit
# fi
#
touch ~/awesome-startup

# BACKGROUND
steam -silent &
udiskie &
clipcatd &
picom &

# First monitor
floorp &

# Third monitor
64gram-desktop &
dicsord --start-minimized &

# STUFF
~/.config/awesome/scripts/layoutchanger.bash &
~/.config/awesome/scripts/wallpaper.sh &
/usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &

# Monitors setup
xrandr --output DisplayPort-0 --primary --mode 1920x1080 \
	--output DisplayPort-1 --mode 1920x1080 --left-of DisplayPort-0 \
	--output HDMI-A-0 --rate 74.97 --mode 1920x1080 --right-of DisplayPort-0 &
