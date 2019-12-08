#!/bin/sh
display_seconds=2
font=$(sed -n 's/st.font: \(.*\)/\1/p' ~/.Xresources)
logfile=~/.local/libnotify.log

if [ "$#" -gt "0" ]; then
	echo $@ | dzen2 -p $display_seconds -fn "$font" -xs 0
	echo "$(date): $@" >> ~/.local/libnotify.log
fi
