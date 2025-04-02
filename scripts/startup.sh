#!/usr/bin/env bash

# if [ -f ~/awesome-startup ]; then
#     exit
# fi
#
touch ~/awesome-startup

~/.config/awesome/scripts/layoutchanger.bash &
steam -silent &
udiskie &
floorp &
64gram-desktop -startintray &
vesktop --start-minimized &
xrandr -r 75 &
clipcatd &
#/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
/usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &
# dunst &
picom &
# flameshot & disown &
