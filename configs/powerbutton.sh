#!/bin/bash
set -x
function ask {
	echo "yad --center --image \"dialog-question\" --title \"Alert\" --button=gtk-yes:\"$2\" --button=gtk-no:1 --text \"$1?\""
}

menu="\
Suspend!bash -c 'slock & systemctl suspend'\
|Shut Down!$(ask 'Shut Down' 'systemctl poweroff')\
|Restart!$(ask 'Restart' 'systemctl reboot')\
"

yad --notification --menu="$menu" --image="system-shutdown"  --command=
