#!/bin/sh
set -x
BFILE=~/.brightness
BMAX=100
BMIN=1
if [ ! -f $BFILE ]; then
	echo $BMAX > $BFILE
fi
B=$(cat $BFILE)
set -e
if echo $1 | grep -e '^+\|-' > /dev/null; then
	d=$(echo $1 | sed 's/+//') # remove + but not -
	B=$(expr $B + $d)
	if [ $B -gt $BMAX ]; then
		B=$BMAX
	elif [ $B -lt $BMIN ]; then
		B=$BMIN
	fi
	echo $B > $BFILE
fi

function try_xbacklight {
	B=$1
	xbacklight -set $B
}

function try_xrandr {
	B=$1
	for mon in $(xrandr --listactivemonitors | awk '/^ [0-9]:/{print $4}'); do
		set -e
		xrandr --output $mon --brightness $(bc -l <<< $B/100)
		set +e
	done
}

function try_sys {
	B=$1
	for device in /sys/class/backlight/*; do
		max=$(cat $device/max_brightness)
		echo $(expr $B \* $max / 100) > $device/brightness
	done
}

# Try all ways of setting the backlight
try_xbacklight $B ||
	try_xrandr $B ||
	try_sys $B
