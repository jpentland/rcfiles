#!/bin/sh
symbol=""
echo -n "$symbol $(free -h | awk '/Mem:/{print $3}')"
