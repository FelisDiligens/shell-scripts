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
no-display "$path/stoken-gui.desktop" # Software Token
no-display "$path/stoken-gui-small.desktop" # Software Token (small)
no-display "$path/qv4l2.desktop" # Qt V4L2 test Utility
no-display "$path/qvidcap.desktop" # Qt V4L2 video capture utility
no-display "$path/lstopo.desktop" # Hardware Locality lstopo
no-display "$path/yad-icon-browser.desktop"
no-display "$path/yad-settings.desktop"
no-display "$path/avahi-discover.desktop" # Avahi Zeroconf Browser
no-display "$path/bssh.desktop" # Avahi SSH Server Browser
no-display "$path/bvnc.desktop" # Avahi VNC Server Browser
no-display "$path/xterm.desktop"
no-display "$path/uxterm.desktop"
no-display "$path/cups.desktop"
# no-display "$path/org.gnome.Meld.desktop"
# no-display "$path/pavucontrol.desktop" # PulseAudio volume control
# KDE:
no-display "$path/assistant.desktop" # Qt Assistant
no-display "$path/designer.desktop" # Qt Designer
no-display "$path/linguist.desktop" # Qt Linguist
no-display "$path/qdbusviewer.desktop" # Qt QDBusViewer
no-display "$path/org.kde.kuserfeedback-console.desktop" # UserFeedback-Konsole