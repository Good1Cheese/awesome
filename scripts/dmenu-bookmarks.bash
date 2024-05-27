#!/usr/bin/env bash

choice="$(awk -F '=' '{print $1}' "$HOME/.config/awesome/projects" |
	dmenu -l 7 -p "open directory")"
[ -z "$choice" ] && exit 1

path=$(awk "/$choice=/" "$HOME/.config/awesome/projects" | awk -F '=' '{print $2}')
wezterm -e fish -c "yy $path; fish"
