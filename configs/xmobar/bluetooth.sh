#!/bin/sh
alias bt=bluetoothctl
colour="#8888ff"
bt devices | \
	while read device id name; do
		if [ "$(bt info $id | awk '/Connected/{print $2}')" == "yes" ]; then
			echo -n -e " <fc=$colour>\xef\x80\xa5 $name</fc>"
		fi
	done
