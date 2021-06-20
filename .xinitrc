#!/bin/sh

# Additional commands
[ -f ~/.xprofile ] && source ~/.xprofile

# Preferred session
exec dbus-launch --exit-with-session awesome
