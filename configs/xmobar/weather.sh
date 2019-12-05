#!/bin/sh
curl "wttr.in/?format=3" | sed 's/\([a-zA-Z ,]\): \(.*\) \([+-]*[0-9]\+\)/\1: <fn=2>\2<\/fn>\3/'
