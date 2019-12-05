#!/bin/sh
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
				echo -n -e "\xef\x87\xab $name | "
				;;
			"ethernet")
				echo -n -e "\xef\x83\xa8 | "
				;;
			"vpn")
				echo -n -e "\xef\x80\xa3 $name | "
				;;
			*)
				;;
		esac
	done | \
		sed 's/ | $//'