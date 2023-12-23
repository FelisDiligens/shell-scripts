#!/bin/bash

if ! [ -x "$(command -v woff2_decompress)" ]; then
    echo "Please install woff2"
    return 1
fi

set -e

wget "https://virgil.excalidraw.com/Virgil.woff2"
woff2_decompress "Virgil.woff2"
mkdir -p "$HOME/.fonts"
mv -v "Virgil.ttf" "$HOME/.fonts"
fc-cache
rm -v Virgil.woff2*
echo "Done."
