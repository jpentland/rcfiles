#!/bin/bash
TMP_FLE=/tmp/$USER-$0-running
set -x
function ask {
	echo "yad --center --image \"dialog-question\" --title \"Alert\" --button=gtk-yes:\"$2\" --button=gtk-no:1 --text \"$1?\""
}

menu="\
Suspend!bash -c 'slock & systemctl suspend'\
|Shut Down!$(ask 'Shut Down' 'systemctl poweroff')\
|Restart!$(ask 'Restart' 'systemctl reboot')\
"

if [ -f $TMP_FILE ]; then exit 0

touch $TMP_FILE
yad --notification --menu="$menu" --image="system-shutdown"  --command=
rm $TMP_FILE
