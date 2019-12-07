#!/bin/sh
#curl "wttr.in/?format=1" | sed 's/\([a-zA-Z ,]\): \(.*\) \([+-]*[0-9]\+\)/\1: <fn=2>\2<\/fn>\3/'
json=$(curl "wttr.in/?format=j1")
condition=$(echo $json | jq ".current_condition []")
temp=$(echo $condition | jq " .temp_C" | sed 's/\"//g')
code=$(echo $condition | jq " .weatherCode" | sed 's/\"//g')

function codetodesc {
	case $1 in
	113)
		echo "Sunny"
		;;
	116)
	   	echo	"PartlyCloudy"
	   	;;
	119)
	  	echo "Cloudy"
	  	;;
	122)
	 	echo "VeryCloudy"
	 	;;
	143)
		echo "Fog"
		;;
	176)
	   echo	"LightShowers"
	   ;;
	179)
	   echo	"LightSleetShowers"
	   ;;
	182)
	   echo	"LightSleet"
	   ;;
	185)
	   echo	"LightSleet"
	   ;;
	200)
	   echo	"ThunderyShowers"
	   ;;
	227)
	   echo	"LightSnow"
	   ;;
	230)
	   echo	"HeavySnow"
	   ;;
	248)
	   echo	"Fog"
	   ;;
	260)
	   echo	"Fog"
	   ;;
	263)
	   echo	"LightShowers"
	   ;;
	266)
	   echo	"LightRain"
	   ;;
	281)
	   echo	"LightSleet"
	   ;;
	284)
	   echo	"LightSleet"
	   ;;
	293)
	   echo	"LightRain"
	   ;;
	296)
	   echo	"LightRain"
	   ;;
	299)
	   echo	"HeavyShowers"
	   ;;
	302)
	   echo	"HeavyRain"
	   ;;
	305)
	   echo	"HeavyShowers"
	   ;;
	308)
	   echo	"HeavyRain"
	   ;;
	311)
	   echo	"LightSleet"
	   ;;
	314)
	   echo	"LightSleet"
	   ;;
	317)
	   echo	"LightSleet"
	   ;;
	320)
	   echo	"LightSnow"
	   ;;
	323)
	   echo	"LightSnowShowers"
	   ;;
	326)
	   echo	"LightSnowShowers"
	   ;;
	329)
	   echo	"HeavySnow"
	   ;;
	332)
	   echo	"HeavySnow"
	   ;;
	335)
	   echo	"HeavySnowShowers"
	   ;;
	338)
	   echo	"HeavySnow"
	   ;;
	350)
	   echo	"LightSleet"
	   ;;
	353)
	   echo	"LightShowers"
	   ;;
	356)
	   echo	"HeavyShowers"
	   ;;
	359)
	   echo	"HeavyRain"
	   ;;
	362)
	   echo	"LightSleetShowers"
	   ;;
	365)
	   echo	"LightSleetShowers"
	   ;;
	368)
	   echo	"LightSnowShowers"
	   ;;
	371)
	   echo	"HeavySnowShowers"
	   ;;
	374)
	   echo	"LightSleetShowers"
	   ;;
	377)
	   echo	"LightSleet"
	   ;;
	386)
	   echo	"ThunderyShowers"
	   ;;
	389)
	   echo	"ThunderyHeavyRain"
	   ;;
	392)
	   echo	"ThunderySnowShowers"
	   ;;
	395)
	   echo	"HeavySnowShowers"
	   ;;
esac
}

case $(codetodesc $code) in
    Unknown)
		echo -n -e ?
		;;
    Cloudy)
		echo -n -e "\ufa8f"
		;;
    Fog)
		echo -n -e "\ufa90"
		;;
    HeavyRain)
		echo -n -e "\ufa95"
		;;
    HeavyShowers)
		echo -n -e "\ufa96"
		;;
    HeavySnow)
		echo -n -e "\ufa97"
		;;
    HeavySnowShowers)
		echo -n -e "\ue35e"
		;;
    LightRain)
		echo -n -e "\ufa96"
		;;
    LightShowers)
		echo -n -e "\ue309"
		;;
    LightSleet)
		echo -n -e "\ue3ad"
		;;
    LightSleetShowers)
		echo -n -e "\ue3ad"
		;;
    LightSnow)
		echo -n -e "\ue35e"
		;;
    LightSnowShowers)
		echo -n -e "\ue35e"
		;;
    PartlyCloudy)
		echo -n -e "\ufa94"
		;;
    Sunny)
		echo -n -e "\ufaa7"
		;;
    ThunderyHeavyRain)
		echo -n -e "\ue31d"
		;;
    ThunderyShowers)
		echo -n -e "\ue31d"
		;;
    ThunderySnowShowers)
		echo -n -e "\ue336"
		;;
    VeryCloudy)
		echo -n -e "\ufa8f"
		;;
esac

if [ "$temp" -lt "5" ]; then
    col="#aaaaff"
elif [ "$temp" -gt "30" ]; then
    col="#ff0000"
else
    col="#ffffff"
fi
echo -n -e " <fc=$col>$temp\u00b0C</fc>"
