#!/bin/sh -x

# Usage: dropdown.sh [--role <role>] <spawn command> <class> <posx> <posy> <sizex> <sizey> <yoff>
if [ "$1" == "--role" ]; then
        shift
        role="$1"; shift
else
        role=
fi

spawn=$1; shift
class=$1; shift

# Position in percentage of monitor size
PX=$1; shift
PY=$1; shift

# Size in percentage of monitor size
SX=$1; shift
SY=$1; shift

# Y Offset in absolute pixels (to avoid bar)
YOFF=$1; shift

# Get role of a wid
function get_role {
        wid=$1; shift
        xprop -id $wid | sed -n '/ROLE/s/.*"\(.*\)"/\1/p'
}

# Get wids associated with role and class
function get_wids {
        if [ -z "$role" ]; then
                xdotool search --class $class
        else
                for wid in $(xdotool search --class $class); do
                        if [ "$(get_role $wid)" == "$role" ]; then
                                echo $wid
                        fi
                done
        fi
}

# Calculate size in pixels
read screen_width screen_height screen_x screen_y borderWidth \
        <<< "$(bspc query -T -m focused \
        | jq '.rectangle.width, .rectangle.height, .rectangle.x, .rectangle.y, .borderWidth' \
        | tr '\n' ' ')"
RPX=$(bc <<< "($screen_width * $PX) / 100 + $screen_x")
RPY=$(bc <<< "($screen_height * $PY) / 100 + $YOFF + $screen_y")
RSX=$(bc <<< "($screen_width * $SX) / 100 - ($borderWidth * 2)")
RSY=$(bc <<< "(($screen_height - $YOFF) * $SY) / 100 - ($borderWidth * 2)")

# Spawn window if it does not exist
wids=$(get_wids)
if [ -z "$wids" ]; then
        bspc rule -a $class -o state=floating hidden=on
        ($spawn &)
        sleep 0.3
        wids=$(get_wids)
fi

# Fail if wid didn't appear
if [ -z "$wids" ]; then
        echo "Failed to start $spawn" 1>&2
        exit 1
fi

# Move window into place before showing it
for wid in $wids; do
        if [ -z "$(bspc query -N -n $wid.\!hidden -d focused -m focused)" ]; then
                xdotool windowmove $wid $RPX $RPY
                xdotool windowsize $wid $RSX $RSY
                bspc node $wid -g hidden=off -d focused -f -t floating
        else
                bspc node $wid -g hidden=on -f
        fi
done
