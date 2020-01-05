#!/bin/sh
function getdefaultsinkname {
    pacmd stat | awk -F": " '/^Default sink name: /{print $2}'
}

function getdefaultsinkvol {
    pacmd list-sinks |
        awk '/^\s+name: /{indefault = $2 == "<'$(getdefaultsinkname)'>"}
            /^\s+volume: / && indefault {print $5; exit}'

}

function getdefaultsinkmuted {
    pacmd list-sinks |
        awk '/^\s+name: /{indefault = $2 == "<'$(getdefaultsinkname)'>"}
            /^\s+muted: / && indefault {print $2; exit}'

}

muted="\xef\x91\xa6"
off="\xef\x80\xa6"
low="\xef\x80\xa7"
high="\xef\x80\xa8"

vol=$(getdefaultsinkvol | sed 's/%//')
if [ "$(getdefaultsinkmuted)" == "yes" ]; then
    echo -n -e "$muted"
elif [ "$vol" == "0" ]; then
    echo -n -e "$off"
elif [ "$vol" -lt "50" ]; then
    echo -n -e "$low $vol%"
else
    echo -n -e "$high $vol%"
fi
echo
