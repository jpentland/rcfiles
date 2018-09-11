#!/bin/sh
alias SPOTIFY=~/.gem/ruby/2.5.0/bin/spotify-dbus
alias YOUTUBE="xdotool search --name '\- Youtube' key"

case $1 in
"play")
	# Play/Pause spotify if no youtube
	YOUTUBE space || SPOTIFY Play
	;;
"playpause")
	YOUTUBE space || SPOTIFY PlayPause
	;;
"pause")
	YOUTUBE space || SPOTIFY Pause
	;;
"next")
	SPOTIFY Next
	;;
"prev")
	SPOTIFY Prev
	;;
esac
