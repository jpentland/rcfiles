#!/bin/sh
set -xe
json=$(curl -s http://api.coindesk.com/v1/bpi/currentprice/USD.json)
ratefloat=$(echo $json | jq '.bpi .USD .rate_float')
rate=$(printf "%.0f" $ratefloat)

yesterday=$(date -d "yesterday 13:00" "+%Y-%m-%d")
yesterdayjson=$(curl -s "https://api.coindesk.com/v1/bpi/historical/close.json?start=$yesterday&end=$yesterday")
yesterdayratefloat=$(echo "$yestedayjson" | jq ".bpi .\"$yesterday\"")

diff=$(printf "%.2f" $(bc -l <<< "(1 - ( $yesterdayratefloat / $ratefloat ) ) * 100"))
echo -n -e "\xef\x85\x9a = \$$rate $diff"
