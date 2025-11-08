#!/usr/bin/env bash

# if [ -f ~/awesome-startup ]; then
#     exit
# fi
#
touch ~/awesome-startup

# BACKGROUND
# steam -silent &
xsct 4000 &
udiskie &
clipcatd &
picom &
ydotoold &

# Notifications
mako &

# First monitor
librewolf &
firefox &

# Second monitor
AyuGram &
# discord &

# STUFF
~/.config/awesome/scripts/layoutchanger.bash &
~/.config/awesome/scripts/wallpaper.sh &
~/.config/awesome/scripts/computer-break-reminder.sh &
/usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &

# Monitors setup
# xrandr --output DP-1 --primary --mode 1920x1080 \
# 	--output DP-2 --mode 1920x1080 --left-of DP-1 \
# 	--output HDMI-1 --rate 74.97 --mode 1920x1080 --right-of DP-1 &

# xrandr --output DP-2 --mode 1920x1080 --right-of HDMI-1 \
# 	--primary --output HDMI-1 --rate 74.97 --mode 1920x1080 &

xrandr --output DP-2 --mode 1920x1080 --rotate left --left-of HDMI-1 \
          --primary --output HDMI-1 --rate 74.97 --mode 1920x1080 &
