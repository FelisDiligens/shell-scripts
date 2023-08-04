#!/bin/bash
# https://openrgb.org/releases.html

# Get some system information:
arch="$(uname -m)"
case "$(uname -m)" in
    x86_64)  arch="amd64" ;;
    aarch64) arch="arm64" ;;
esac

download_folder=$(xdg-user-dir DOWNLOAD)

# Extract download URL from homepage:
id="bookworm" # Debian 12
hostname="openrgb.org"
download_links=$(curl "https://openrgb.org/releases.html" | grep -o -E "\/releases\/release_[0-9\.]+\/openrgb_[0-9\.]+_amd64(_[a-z]+)?_[a-z0-9]+\.deb")
download_url="https://$hostname/$(echo "$download_links" | grep -m 1 "$id")"
filename="${download_url##*/}" # https://unix.stackexchange.com/a/325492
echo "Download URL: $download_url"
echo "File name: $filename"
echo

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