#!/bin/bash

configfile="/etc/systemd/logind.conf"

function change-value () {
    # If key exists in file:
    if grep -q "$1=" "$configfile"; then
        # then determine line number
        linenumber=$(grep -n "$1=" "$configfile" | cut -f1 -d:)
        # and replace line with new value
        sed -i "${linenumber}s/.*/$1=$2/" "$configfile"
    else
        # otherwise just append to file:
        echo "$1=$2" >> "$configfile"
    fi
}

if [ -f "$configfile" ]; then
    change-value "HandleSuspendKey" "ignore"
    change-value "HandleLidSwitch" "ignore"
    change-value "HandleLidSwitchExternalPower" "ignore"
    change-value "HandleLidSwitchDocked" "ignore"
    echo "Done."
else
    echo "$configfile not found."
fi