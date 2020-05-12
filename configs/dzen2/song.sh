#!/bin/sh
playing="\uf001"
paused="\uf04c"
status=$(playerctl status)
if grep -q "Playing" <<< "$status"; then
	icon=$playing
	data="$(playerctl metadata)"
	title=$(echo "$data" | sed -n 's/.*:title \+\(.*\)/\1/p')
	artist=$(echo "$data" | sed -n 's/.*:artist \+\(.*\)/\1/p')
	echo -e " $icon $title - $artist "
elif grep -q "Paused" <<< "$status"; then
	icon=$paused
	echo -e " $icon"
else
	echo
	exit 0
fi

