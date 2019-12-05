#!/bin/sh
json=$(curl -s http://api.coindesk.com/v1/bpi/currentprice/USD.json)
rate=$(echo $json | jq '.bpi .USD .rate_float')
intrate=$(printf "%.0f" $rate)

yd=$(date -d "yesterday 13:00" "+%Y-%m-%d")
ydjson=$(curl -s "https://api.coindesk.com/v1/bpi/historical/close.json?start=$yd&end=$yd")
ydrate=$(echo "$ydjson" | jq ".bpi .\"$yd\"")
diff=$(printf "%.2f" $(bc -l <<< "(1 - ( $ydrate / $rate ) ) * 100"))
diffint=$(printf "%d" $(bc -l <<< "$diff * 100"))

bticon="<fc=#ffcc00>\xef\x85\x9a</fc>"

if [ "$diffint" -lt "0" ]; then
	echo -n -e "$bticon = <fc=#ff0000>\$$intrate</fc>"
else
	echo -n -e "$bticon = <fc=#00ff00>\$$intrate</fc>"
fi
