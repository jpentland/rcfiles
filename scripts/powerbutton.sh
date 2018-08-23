#!/bin/bash
TMP_FILE=/tmp/$USER-$(basename $0)-running
set -x
function ask {
	echo "yad --center --image \"dialog-question\" --title \"Alert\" --button=gtk-yes:\"$2\" --button=gtk-no:1 --text \"$1?\""
}

function cleanup {
	kill $(cat $TMP_FILE); rm -f $TMP_FILE
}

menu="\
Suspend!bash -c 'slock & systemctl suspend'\
|Shut Down!$(ask 'Shut Down' 'systemctl poweroff')\
|Restart!$(ask 'Restart' 'systemctl reboot')\
"

if ps -A | grep $(cat $TMP_FILE); then exit 0; fi

yad --notification --menu="$menu" --image="system-shutdown"  --command= &
echo $! > $TMP_FILE
trap 'echo recieved SIGINT; cleanup;' SIGINT
wait
cleanup
