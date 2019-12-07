#!/bin/sh
newmail=$(find ~/.local/share/mail/*/*/new -type f | wc -l)
icon="\uf6ed"
if [ "$newmail" -gt "0" ]; then
	echo -e -n "$icon $newmail"
fi
