#!/bin/bash

if [ -f ~/awesome-startup ]; then
    exit
fi

touch ~/awesome-startup

udiskie &
firefox &
telegram-desktop -startintray &
discord --start-minimized &
compfy -b &
setxkbmap -layout 'us,ru' -option 'grp:alt_shift_toggle' &
redshift -x; redshift -O 3500 &
xset r rate 200 35; setxkbmap -option caps:escape &
flameshot & disown &
