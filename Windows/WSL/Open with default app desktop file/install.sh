#!/bin/bash
sudo cp -vf open-with-windows-default-app.desktop /usr/share/applications/
sudo cp -vf open-with-windows-default-app.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/open-with-windows-default-app.sh
sudo update-desktop-database
