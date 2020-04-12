#!/bin/sh

MONITOR="DP-1"
TV="HDMI-3"

case "$1" in
	1)
		xrandr --output $MONITOR --auto --primary \
            --output $TV --off
        lgwebos off
		;;
	2)
        lgwebos on &
		xrandr --output $MONITOR --auto --primary \
            --output $TV --right-of $MONITOR --mode 1920x1080 --noprimary
		;;
	3)
        lgwebos on &
		xrandr --output $MONITOR --auto --primary \
            --output $TV --right-of $MONITOR --mode 4096x2160 --noprimary
		;;
	4)
        lgwebos on &
		xrandr --output $MONITOR --off \
            --output $TV --mode 1920x1080 --primary
		;;
	5)
		xrandr --output $TV --off
		;;
	6)
		xrandr --output $TV --right-of "HDMI-2" --auto
		;;
esac
