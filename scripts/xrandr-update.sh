#!/bin/sh
BFILE=~/.brightness
XCONF=~/.xrandr.conf
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

BS=$(printf "0.%02d" $B)
CONF=$(cat $XCONF | grep -v '^#' | sed "s/\(.\+\)/\1 --brightness $BS/")
xrandr $CONF
