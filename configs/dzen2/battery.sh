#!/bin/sh
full="  "
high="  "
medium="  "
low="  "
empty="  "
powered=""

battery=$( upower -e | grep battery | sed 1q )
power=$(upower -e | grep 'line_power' | sed 1q)

charge=$(upower -i $battery | awk '/percentage/{print $2}' | sed 's/%//')
online=$(upower -i $power | awk '/online/{print $2}')

if [ "$charge" -gt 95 ]; then
	icon=$full
	color="#00ff00"
elif [ "$charge" -gt 75 ]; then
	icon=$high
	color="#22ff22"
elif [ "$charge" -gt 40 ]; then
	icon=$medium
	color="#ff0088"
elif [ "$charge" -gt 10 ]; then
	icon="$low ($charge)"
	color="#ff0000"
else
	icon="$empty ($charge)"
	color="#ff0000"
fi

if [ "$online" == "yes" ]; then
	echo -n -e "^fg(#ffcc00)$powered^fg() "
	if [ "$charge" -lt "99" ]; then
		echo -n -e "^fg(#00ff00)$icon^fg()"
	fi
else
	echo -n -e "^fg($color)$icon^fg()"
fi


echo
