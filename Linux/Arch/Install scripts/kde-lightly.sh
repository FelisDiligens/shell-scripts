#!/bin/bash
# https://github.com/boehs/Lightly

echo "Installing prerequisites..."
sudo pacman -S git cmake extra-cmake-modules kdecoration qt5-declarative qt5-x11extras

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