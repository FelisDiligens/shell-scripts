#!/bin/bash

# Turn display on/off

METHOD="vbetool" # Methods: "xset", "xrandr", "vbetool"
# Use vbetool if in TTY, use xset or xrandr if in Xorg.

DISPLAY=":0"     # Required for "x*" methods
OUTPUT="eDP-1"   # Required for "xrandr" method

if [ -n "$1" ] && [ "$1" = "off" ]; then
    echo "Turning off screen with $METHOD"
    case "$METHOD" in
        "xset") xset -display $DISPLAY dpms force off ;;
        "xrandr") xrandr --display $DISPLAY --output $OUTPUT --off ;;
        "vbetool") vbetool dpms off ;;
        "*") echo "Invalid method: $METHOD" ;;
        # xrandr --display $DISPLAY --output $OUTPUT --brightness 0
    esac
elif [ -n "$1" ] && [ "$1" = "on" ]; then
    echo "Turning on screen with $METHOD"
    case "$METHOD" in
        "xset") xset -display $DISPLAY dpms force on ;;
        "xrandr") xrandr --display $DISPLAY --output $OUTPUT --auto --brightness 1 ;;
        "vbetool") vbetool dpms on ;;
        "*") echo "Invalid method: $METHOD" ;;
    esac
else
    echo "usage: ./display.sh [on|off]"
fi