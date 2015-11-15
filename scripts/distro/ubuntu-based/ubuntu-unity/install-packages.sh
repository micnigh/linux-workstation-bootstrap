#!/bin/bash

# auto start docker daemon
sudo systemctl enable docker

sudo apt-get install -y unity-tweak-tool compizconfig-settings-manager

# workaround so we dont need to install unity-webapps-service package
# http://askubuntu.com/a/653634
TEMP_DIR=$(mktemp -d)
cd $TEMP_DIR
apt-get download unity-webapps-service
ar xvf *
tar xvf data*
mv usr/share/glib-2.0/schemas/com.canonical.unity.webapps.gschema.xml /usr/share/glib-2.0/schemas/
glib-compile-schemas /usr/share/glib-2.0/schemas/
rm -rf $TEMP_DIR

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
