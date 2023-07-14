#!/bin/bash

# Turn display on/off

DISPLAY=":0"
OUTPUT="eDP-1"
METHOD="xset" # "xrandr"

if [ -n "$1" ] && [ "$1" = "off" ]; then
    echo "Turning off screen with $METHOD"
    case "$METHOD" in
        "xset") xset -display $DISPLAY dpms force off ;;
        "xrandr") xrandr --display $DISPLAY --output $OUTPUT --off ;;
        "*") echo "Invalid method: $METHOD" ;;
        # xrandr --display $DISPLAY --output $OUTPUT --brightness 0
    esac
elif [ -n "$1" ] && [ "$1" = "on" ]; then
    echo "Turning on screen with $METHOD"
    case "$METHOD" in
        "xset") xset -display $DISPLAY dpms force on ;;
        "xrandr") xrandr --display $DISPLAY --output $OUTPUT --auto --brightness 1 ;;
        "*") echo "Invalid method: $METHOD" ;;
    esac
else
    echo "usage: ./display.sh [on|off]"
fi