#!/bin/bash
# https://github.com/elFarto/nvidia-vaapi-driver

echo "Installing prerequisites..."
sudo apt install git curl cabextract dkms "linux-headers-$(uname -r)"

echo "Cloning github.com/medusalix/xone..."
git clone https://github.com/medusalix/xone.git

# Make sure to completely uninstall xone before updating:
echo "Uninstalling xone..."
sudo ./uninstall.sh

echo "Installing xone..."
cd xone
sudo ./install.sh --release
sudo xone-get-firmware.sh --skip-disclaimer # /usr/local/bin/xone-get-firmware.sh

echo "Cleaning up..."
cd ..
rm -rv ./xone
# sudo apt autoremove cabextract