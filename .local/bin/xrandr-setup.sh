#!/bin/sh

case "$1" in
	1)
		xrandr --output HDMI-3 --off
		;;
	2)
		xrandr --output HDMI-3 --right-of DP-1 --mode 1920x1080 --noprimary
		;;
	3)
		xrandr --output HDMI-3 --right-of DP-1 --mode 4096x2160 --noprimary
		;;
esac
