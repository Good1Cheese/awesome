#!/usr/bin/env bash

# if [ -f ~/awesome-startup ]; then
#     exit
# fi
#
touch ~/awesome-startup

~/.config/awesome/layoutchanger.bash &
steam -silent &
udiskie &
librewolf &
telegram-desktop -startintray &
discord --start-minimized &
clipmenud &
#/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
compfy -b &
# flameshot & disown &
