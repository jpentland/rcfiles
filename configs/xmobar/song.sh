#!/bin/sh
icon="\uf001"
if [ "$(playerctl status)" != "Playing" ]; then
	exit 0
fi

data="$(playerctl metadata)"
title=$(echo "$data" | sed -n 's/.*:title \+\(.*\)/\1/p')
artist=$(echo "$data" | sed -n 's/.*:artist \+\(.*\)/\1/p')
echo -n -e "$icon $title - $artist"
