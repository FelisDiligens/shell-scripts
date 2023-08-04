#!/bin/bash
# https://github.com/boehs/Lightly

echo "Installing prerequisites..."
sudo apt install git cmake build-essential libkf5config-dev libkdecorations2-dev libqt5x11extras5-dev qtdeclarative5-dev extra-cmake-modules libkf5guiaddons-dev libkf5configwidgets-dev libkf5windowsystem-dev libkf5coreaddons-dev libkf5iconthemes-dev gettext qt3d5-dev

echo "Cloning github.com/boehs/Lightly..."
git clone --single-branch --depth=1 https://github.com/boehs/Lightly.git

echo "Installing Lightly..."
cd Lightly && mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib -DBUILD_TESTING=OFF ..
make
sudo make install

echo "Cleaning up..."
cd ../..
rm -rv ./Lightly