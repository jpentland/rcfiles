#!/bin/bash

# Kill before starting
function killstart {
	ps -U $USER | grep $1 | awk '{print $1}' | xargs -n1 kill
	$@
}

# Don't start if already running
function singlestart {
	if ! ps -U $USER | grep $1; then
		$@
	fi
}

# Update screen config
autorandr

# Background image
feh --bg-scale ~/.xmonadbg

# Set default cursor
xsetroot -cursor_name left_ptr

# Keyboard layout
setxkbmap gb

# Default apps
killstart trayer $(cat ~/.trayer.conf | grep -ve '^#') &
nm-applet &
singlestart pasystray &
singlestart cbatticon &
~/.local/bin/powerbutton.sh &
killall redshift; killstart redshift-gtk -l 52.520645:13.409779 & # berlin, make configurable later
singlestart yakuake &

# Dont kill everything when script ends
wait
