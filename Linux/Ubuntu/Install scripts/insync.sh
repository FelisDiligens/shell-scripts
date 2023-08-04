#!/bin/bash
# https://www.insynchq.com/downloads/linux
# Note: Insync only supports 64-bit.

# Get some system information:
. /etc/os-release
if [ $ID != "ubuntu" ]; then
    echo "Not ubuntu"
    exit 1
fi

download_folder=$(xdg-user-dir DOWNLOAD)

# Determine download URL:
download_url="https://dl.insynchq.com/linux/desktop/ubuntu/$VERSION_ID"

# Download file:
# https://superuser.com/a/1146162
echo "Downloading *.deb file..."
filepath=$(wget --content-disposition --directory-prefix="$download_folder" -nv "$download_url" 2>&1 | cut -d\" -f2)

# Install *.deb:
echo "Installing..."
sudo apt install "$filepath" # "$download_folder/$filename"

# Remove file:
echo "Cleaning up..."
rm -v "$filepath" # "$download_folder/$filename"

echo "Done."