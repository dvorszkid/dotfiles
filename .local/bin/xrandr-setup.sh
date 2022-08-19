#!/bin/sh

DELL_2408="DP-1"
DELL_2415="HDMI-3"

case "$1" in
	1)
		xrandr --output $DELL_2408 --off
		;;
	2)
        #lgwebos on &
		xrandr --output $DELL_2408 --right-of $DELL_2415 --auto --noprimary
		;;
	3)
		xrandr --output $DELL_2415 --mode 1920x1200 --primary \
            --output $DELL_2408 --off
        #lgwebos off &
		;;
	4)
		xrandr --output $DELL_2415 --auto --primary \
            --output $DELL_2408 --right-of $DELL_2415 --mode 1920x1200 --noprimary
		;;
esac
