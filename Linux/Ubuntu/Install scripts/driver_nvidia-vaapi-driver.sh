#!/bin/bash
# https://github.com/elFarto/nvidia-vaapi-driver

echo "Installing prerequisites..."
sudo apt install git meson gstreamer1.0-plugins-bad libffmpeg-nvenc-dev libva-dev libegl-dev libgstreamer-plugins-bad1.0-dev

echo "Cloning github.com/elFarto/nvidia-vaapi-driver..."
git clone https://github.com/elFarto/nvidia-vaapi-driver.git

echo "Building driver..."
cd nvidia-vaapi-driver
meson setup build
meson install -C build

echo "Cleaning up..."
cd ..
rm -rv ./nvidia-vaapi-driver
# sudo apt autoremove meson gstreamer1.0-plugins-bad libffmpeg-nvenc-dev libva-dev libegl-dev libgstreamer-plugins-bad1.0-dev