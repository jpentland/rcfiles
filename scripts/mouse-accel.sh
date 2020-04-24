#!/bin/sh
# Rerun mouse accel setup on new input devices
SPEED=-0.8
function set_mouse_speed {
        speed=$1
        deviceids="$(xinput list | sed -n '/[Mm]ouse/s/.*id=\([0-9]\+\).*/\1/p')"
        for device in $deviceids; do
                xinput --set-prop $device 'libinput Accel Speed' $speed
        done
}

set_mouse_speed $SPEED
udevadm monitor --subsystem=input | while read line; do
        set_mouse_speed $SPEED
done
