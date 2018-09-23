#!/bin/sh

TEXT=$(rofi -dmenu -lines 0 -format s -p "translate" -filter "autodetect;en;")
FROM=$(cut -d ';' -f 1 <<< $TEXT)
TO=$(cut -d ';' -f 2 <<< $TEXT)
TEXT=$(cut -d ';' -f 3 <<< $TEXT)
TTEXT=$(translate-cli --output_only --from "$FROM" --to "$TO" "$TEXT")
rofi -e "[$FROM -> $TO] $TTEXT"
