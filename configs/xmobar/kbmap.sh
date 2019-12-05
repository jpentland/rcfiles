#!/bin/sh
icon="\uf11c"
map=$(setxkbmap -query | awk '/layout/{print $2}')

echo -n -e "$icon $map"
