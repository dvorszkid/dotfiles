#!/bin/sh

MONITOR="DP-1"
TV="HDMI-3"

case "$1" in
	1)
		xrandr --output $TV --off
		;;
	2)
		xrandr --output $TV --right-of $MONITOR --mode 1920x1080 --noprimary
		;;
	3)
		xrandr --output $TV --right-of $MONITOR --mode 4096x2160 --noprimary
		;;
esac
