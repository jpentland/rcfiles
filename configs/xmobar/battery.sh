#!/bin/sh
full=""
high=""
medium=""
low=""
empty=""
powered=""

battery=$( upower -e | grep battery | sed 1q )
power=$(upower -e | grep 'line_power' | sed 1q)

charge=$(upower -i $battery | awk '/percentage/{print $2}' | sed 's/%//')
online=$(upower -i $power | awk '/online/{print $2}')

if [ "$online" == "yes" ]; then
	echo -n -e "<fc=#ffcc00>$powered</fc> "
fi

if [ "$charge" -gt 95 ]; then
	echo -n -e "<fc=#00ff00>$full</fc>"
elif [ "$charge" -gt 75 ]; then
	echo -n -e "$high"
elif [ "$charge" -gt 50 ]; then
	echo -n -e "$medium"
elif [ "$charge" -gt 10 ]; then
	echo -n -e "<fc=#ff0000>$low</fc>"
else
	echo -n -e "$empty"
fi
