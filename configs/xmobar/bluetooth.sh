#!/bin/sh
alias bt=bluetoothctl
bt devices | \
	while read device id name; do
		if [ "$(bt info $id | awk '/Connected/{print $2}')" == "yes" ]; then
			echo -n -e "\xef\x80\xa5 $name | "
		fi
	done | \
		sed 's/ | $//'
