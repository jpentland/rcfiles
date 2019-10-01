#!/bin/sh
BFILE=~/.brightness
BMAX=99
BMIN=0
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

# Try all ways of setting the backlight
xbacklight -set $B || \
	for mon in $(xrandr --listactivemonitors | grep -o ' [^ ]*$' | tail -n-1); do
		xrandr --output $mon --brightness 0.$B
	done
