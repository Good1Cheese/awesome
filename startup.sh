#!/bin/bash

if [ -f ~/awesome-startup ]; then
    exit
fi

touch ~/awesome-startup

steam -silent &
udiskie &
firefox &
telegram-desktop -startintray &
discord --start-minimized &
clipmenud &
compfy -b &
flameshot & disown &
