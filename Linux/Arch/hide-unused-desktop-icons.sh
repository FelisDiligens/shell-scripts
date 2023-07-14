#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Run as root."
    exit 1
fi

function no-display {
    # If the file exists and doesn't contain "NoDisplay=":
    if [ -f "$1" ] && ! grep -q "NoDisplay=" "$1"; then
        # then append this line to the file:
        echo "NoDisplay=true" >> "$1"
    fi
}

path="/usr/share/applications"
no-display "$path/stoken-gui.desktop"
no-display "$path/stoken-gui-small.desktop"
no-display "$path/qv4l2.desktop"
no-display "$path/qvidcap.desktop"
no-display "$path/lstopo.desktop"
no-display "$path/yad-icon-browser.desktop"
no-display "$path/yad-settings.desktop"
no-display "$path/avahi-discover.desktop"
no-display "$path/bssh.desktop"
no-display "$path/bvnc.desktop"
no-display "$path/xterm.desktop"
no-display "$path/cups.desktop"