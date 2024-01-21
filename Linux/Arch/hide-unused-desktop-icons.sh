#!/bin/bash

path="/usr/share/applications"
if [ "$EUID" -ne 0 ]; then
    echo "Warning: Not running as root."
    path="$HOME/.local/share/applications"
fi
echo "Using path $path"

function no-display {
    # If the file exists and doesn't contain "NoDisplay=":
    if [ -f "$1" ] && ! grep -q "NoDisplay=" "$1"; then
        # then append this line to the file:
        echo "NoDisplay=true" >> "$1"
    fi
}

no-display "$path/stoken-gui.desktop" # Software Token
no-display "$path/stoken-gui-small.desktop" # Software Token (small)
no-display "$path/qv4l2.desktop" # Qt V4L2 test Utility
no-display "$path/qvidcap.desktop" # Qt V4L2 video capture utility
no-display "$path/lstopo.desktop" # Hardware Locality lstopo
no-display "$path/yad-icon-browser.desktop" # Icon Browser (Inspect GTK Icon Theme)
no-display "$path/yad-settings.desktop" # YAD settings
no-display "$path/avahi-discover.desktop" # Avahi Zeroconf Browser
no-display "$path/bssh.desktop" # Avahi SSH Server Browser
no-display "$path/bvnc.desktop" # Avahi VNC Server Browser
no-display "$path/xterm.desktop" # XTerm (good ol' reliable?), dependency for EndeavourOS stuff
no-display "$path/uxterm.desktop" # UXTerm
no-display "$path/cups.desktop" # Manage Printing
# no-display "$path/pavucontrol.desktop" # PulseAudio volume control
# KDE:
no-display "$path/assistant.desktop" # Qt Assistant
no-display "$path/designer.desktop" # Qt Designer
no-display "$path/linguist.desktop" # Qt Linguist
no-display "$path/qdbusviewer.desktop" # Qt QDBusViewer
no-display "$path/org.kde.kuserfeedback-console.desktop" # UserFeedback-Konsole
# Manjaro
no-display "$path/cleanup-manjaro-gnome.desktop"
# HP/Printers:
# no-display "$path/hplip.desktop" # HP Device Manager (View device status, ink levels and perform maintenance.)
no-display "$path/hp-uiscan.desktop"
# Misc:
no-display "$path/electron25.desktop"
no-display "$path/electron28.desktop"
no-display "$path/cmake-gui.desktop"
no-display "$path/xdvi.desktop"
no-display "$path/xgps.desktop"
no-display "$path/xgpsspeed.desktop"
no-display "$path/fish.desktop"
no-display "$path/htop.desktop"
no-display "$path/scrcpy.desktop"
no-display "$path/scrcpy-console.desktop"
no-display "$path/ranger.desktop"
no-display "$path/scim-setup.desktop"
no-display "$path/vim.desktop"
no-display "$path/gsharp.desktop" # C# InteractiveBase Shell - from package mono-tools
no-display "$path/xsane.desktop"

# Remove Steam desktop files:
grep -Ril "steam://run" "$path" | while read -r f; do
    rm -v "$f"
done

update-desktop-database "$path"

if [ "$XDG_CURRENT_DESKTOP" = "KDE" ]; then
    kbuildsycoca5
fi

echo "Done."
