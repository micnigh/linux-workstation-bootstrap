#!/bin/bash

# auto start docker daemon
sudo systemctl enable docker

sudo apt-get install -y unity-tweak-tool

# disable search globally - http://askubuntu.com/a/629255
sudo tee /etc/xdg/autostart/disable_onlinesearch.desktop <<EOF
[Desktop Entry]
Name=Disable Search
Exec=/bin/bash -c "gsettings set com.canonical.Unity.Lenses remote-content-search 'none'"
Type=Application
EOF

# remove amazon launcher - http://askubuntu.com/a/629255
sudo apt-get purge -y unity-webapps-common
sudo rm /usr/share/applications/ubuntu-amazon-default.desktop
