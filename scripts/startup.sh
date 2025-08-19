#!/usr/bin/env bash

# if [ -f ~/awesome-startup ]; then
#     exit
# fi
#
touch ~/awesome-startup

# Night color
xsct 4000;

# BACKGROUND
# steam -silent &
udiskie &
clipcatd &
picom &

librewolf &

# Notifications
mako &

# STUFF
~/.config/awesome/scripts/layoutchanger.bash &
~/.config/awesome/scripts/wallpaper.sh &
/usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &
