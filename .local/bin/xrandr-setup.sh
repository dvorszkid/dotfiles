#!/bin/sh

case "$1" in
	1)
		xrandr --output HDMI3 --off
		;;
	2)
		xrandr --output HDMI3 --right-of DP1 --mode 1920x1080 --noprimary
		;;
esac
