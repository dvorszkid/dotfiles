#!/bin/sh

mv "$1" ~/torrent/watch/
notify-send "[Torrent Started]" "$1"
