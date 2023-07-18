#!/bin/bash

if [ -n "$1" ] && [ "$1" = "enable" ]; then
    echo "Enabling GUI..."
    sudo systemctl set-default graphical.target
    echo "Please reboot now."
elif [ -n "$1" ] && [ "$1" = "disable" ]; then
    echo "Disabling GUI..."
    sudo systemctl set-default multi-user.target
    echo "Please reboot now."
else
    defaulttarget="$(systemctl get-default)"
    if [ "$defaulttarget" = "multi-user.target" ]; then
        echo "Status: GUI is disabled."
    elif [ "$defaulttarget" = "graphical.target" ]; then
        echo "Status: GUI is enabled."
    fi
    echo "Tip: Run this script with \"enable\" or \"disable\" parameter"
fi