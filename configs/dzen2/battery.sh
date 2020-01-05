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
	echo -n -e "^fg(#ffcc00)$powered^fg() "
fi

if [ "$charge" -gt 95 ]; then
	echo -n -e "^fg(#00ff00)$full^fg()"
elif [ "$charge" -gt 75 ]; then
	echo -n -e "$high"
elif [ "$charge" -gt 40 ]; then
	echo -n -e "$medium"
elif [ "$charge" -gt 10 ]; then
	echo -n -e "^fg(#ff0000)$low $charge%^fg()"
else
	echo -n -e "^fg(#ff0000)$empty $charge%^fg()"
fi
echo
