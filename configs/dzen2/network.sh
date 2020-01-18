#!/bin/sh
# Show active network connections
function strength_symbol {
	if [ $1 -lt 10 ]; then
		echo "#ee0000"
	elif [ $1 -lt 20 ]; then
		echo "#ee2200"
	elif [ $1 -lt 30 ]; then
		echo "#dd8800"
	elif [ $1 -lt 30 ]; then
		echo "#cccc00"
	elif [ $1 -lt 40 ]; then
		echo "#88cc00"
	elif [ $1 -lt 50 ]; then
		echo "#77dd00"
	elif [ $1 -lt 60 ]; then
		echo "#44ee00"
	else
		echo "#00cc11"
	fi

}

colour="#aaee88"
echo -n -e "^fg($colour)"
nmcli connection show --active | \
	while read line; do
		name=$(echo "$line" | awk -F '  +' '{print $1}')
		uuid=$(echo "$line" | awk -F '  +' '{print $2}')
		ctype=$(echo "$line" | awk -F '  +' '{print $3}')
		device=$(echo "$line" | awk -F '  +' '{print $4}')

		if [ "$NAME" == "NAME" ]; then
			continue
		fi

		case $ctype in
			"wifi")
				color=$(strength_symbol "$(iwconfig | sed -n 's/.*Quality=\([0-9]\+\).*/\1/p')")
				echo -n -e " ^fg($color)\xef\x87\xab $name^fg()"
				;;
			"ethernet")
				echo -n -e " \xef\x83\xa8"
				;;
			"vpn")
				echo -n -e " \xef\x80\xa3 $name"
				;;
			*)
				;;
		esac
	done

# Show red disconnected symbol if no network access
if ! ping -c3 8.8.8.8 1>&2; then
	echo -n -e "^fg(#ff0000) \uf818^fg() "
fi
echo -n -e "^fg()"
echo
