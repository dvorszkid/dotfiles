#!/bin/sh

CMDS="xset s activate && sleep 10 && xset dpms force standby    # lock and turn off display
xset s activate                                           # lock
poweroff                                                  # shutdown
reboot                                                    # reboot"

CMD=$(echo "$CMDS" | rofi -dmenu -p "AwesomeWM")
eval $CMD
