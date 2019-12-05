#!/bin/sh
full=""
high=""
medium=""
low=""
empty=""
powered=""

battery="/org/freedesktop/UPower/devices/battery_BAT0"
power="/org/freedesktop/UPower/devices/line_power_AC"

charge=$(upower -i $battery | awk '/percentage/{print $2}' | sed 's/%//')
online=$(upower -i $power | awk '/online/{print $2}')

if [ "$online" == "yes" ]; then
	echo -n -e "$powered "
fi

if [ "$charge" -gt 95 ]; then
	echo -n -e "$full"
elif [ "$charge" -gt 75 ]; then
	echo -n -e "$high"
elif [ "$charge" -gt 50 ]; then
	echo -n -e "$medium"
elif [ "$charge" -gt 10 ]; then
	echo -n -e "$low"
else
	echo -n -e "$empty"
fi
