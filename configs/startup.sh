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
picom &
xrdb ~/.Xresources

# Dont kill everything when script ends
wait
