#/bin/sh -x
FORMAT=png
CODE_FILE=/tmp/qrcode.$FORMAT
code="$@"

qrencode -t $FORMAT -o $CODE_FILE <<< "$code"
bspc rule -a fehqrcode:* -o state=floating
feh --class fehqrcode -g 400x400 --scale-down -Z $CODE_FILE -x --force-aliasing
