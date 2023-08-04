#!/bin/bash
# https://github.com/cyanfish/naps2/releases

# Get some system information:
arch="$(uname -m)"
case "$(uname -m)" in
    x86_64)  arch="x64" ;;
    aarch64) arch="arm64" ;;
esac

download_folder=$(xdg-user-dir DOWNLOAD)

# Get latest (pre)release with GitHub API:
echo "Retrieving download URL from GitHub API..."
releases=$(curl "https://api.github.com/repos/cyanfish/naps2/releases")
available_downloads=$(echo "$releases" | jq -r ".[0].assets[].browser_download_url")
download_url=$(echo "$available_downloads" | grep -m 1 -E "linux-$arch.deb\$")
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