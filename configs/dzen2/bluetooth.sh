#!/bin/sh
alias bt=bluetoothctl
colour="#8888ff"
bt devices | \
	while read device id name; do
		if [ "$(bt info $id | awk '/Connected/{print $2}')" == "yes" ]; then
			echo -n -e " ^fg($colour)\uf294 $name^fg()"
		fi
	done
echo
