#!/usr/bin/env bash

# if [ -f ~/awesome-startup ]; then
#     exit
# fi
#
touch ~/awesome-startup

~/.config/awesome/scripts/layoutchanger.bash &
steam -silent &
udiskie &
firefox &
telegram-desktop -startintray &
discord --start-minimized &
clipmenud &
#/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
# compfy -b &
flameshot & disown &
