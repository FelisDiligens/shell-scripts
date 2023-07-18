#!/bin/bash
# This does not remove notes or settings, only the app itself.
rm -rv "$HOME/.joplin"
rm -v "$HOME/.local/share/applications/joplin.desktop"
rm -v "$HOME/.local/share/applications/appimagekit-joplin.desktop"
rm -v "$HOME/.local/share/icons/hicolor/512x512/apps/joplin.png"
update-desktop-database "$HOME/.local/share/applications" "$HOME/.local/share/icons"