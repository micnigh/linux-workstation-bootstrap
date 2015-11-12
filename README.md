Bootstrap guide for new linux workstation setup.

Supports Mint 17.2 Cinnamon or Ubuntu unity 15.10.

# Quick start

```bash

# manually do all upgrades/updates and install drivers
sudo apt-get update;
sudo apt-get install -y upgrade;
sudo apt-get install -y dist-upgrade;

# need curl to run scripts
sudo apt-get install -y curl;

# install packages
sudo -E sh -c 'curl -sSL https://raw.githubusercontent.com/micnigh/linux-workstation-bootstrap/master/scripts/install-packages.sh | bash';

# setup user profile
sh -c 'curl -sSL https://raw.githubusercontent.com/micnigh/linux-workstation-bootstrap/master/scripts/setup-user-profile.sh | bash';

# install ssh keys, then fix permissions
chmod 600 ~/.ssh/
chmod 600 ~/.ssh/id_rsa*

# add dotfiles from git bash
# From [micnigh/linux-dotfiles](https://github.com/micnigh/linux-dotfiles)
cd ~/
git init .
git remote add origin https://github.com/micnigh/linux-dotfiles.git
git fetch --all
git reset --hard origin/master

# add .dotfiles to .bashrc
echo ". ~/.dotfiles.sh" >> ~/.bashrc

# setup git user
git config --global user.email ""
git config --global user.name ""

```

## Extra setup notes

### Dual boot Windows

#### Fix time sync issue

Windows does not use UTC by default - turn this on by adding `dword` key `RealTimeIsUniversal` with value `1` to registry path `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation`

#### Allow access to windows NTFS drive

Windows fast boot and hibernate block access to NTFS drives, so this must be disabled to give us access.

In Windows, go to `Power Settings`, then `what power buttons do` on the left panel and turn off fast startup.  Then back in `PowerSettings`, `change plan settings` and find the sleep section, and turn off hibernate.  Then restart.

### Linux mint 17.2

```bash
# run dropbox setup, then apply fix for transparency of icon
# for some reason dropbox ships their own libGL :(
# https://www.dropboxforum.com/hc/en-us/community/posts/201269689-tray-icon-linux
# TODO: remove when no longer needed
mv ~/.dropbox-dist/dropbox-lnx.x86_64*/libGL.so.1 libGL.so.1.bak
```

### Ubuntu

#### Blank screen when booting livecd

Often related to `nvidia` gpu's, turn on `nomodeset` in kernel params when booting.

#### Add DOD ssl certs

All dod certs from https://militarycac.com/maccerts/ or http://dodpki.c3pki.chamb.disa.mil/rootca.html

##### Install globally into root certificate store

```bash
sudo su

TEMP_DIR=$(mktemp) && \
wget --no-check-certificate https://militarycac.com/maccerts/AllCerts.zip -P $TEMP_DIR && \
unzip -d $TEMP_DIR $TEMP_DIR/AllCerts.zip && \
for f in $TEMP_DIR/*.cer; do mv "$f" "${f%.cer}.crt"; done && \
for f in $TEMP_DIR/*.crt; do mv "$f" "${f// /_}"; done && \
mkdir -p /usr/share/ca-certificates/dod/ && \
cp $TEMP_DIR/*.crt /usr/share/ca-certificates/dod/ && \
rm -rf $TEMP_DIR && \
dpkg-reconfigure ca-certificates
```

##### Install into user account (firefox and chrome only)

```bash
sudo apt-get -y install libnss3-tools

TEMP_DIR=$(mktemp) && \
wget http://dodpki.c3pki.chamb.disa.mil/rel3_dodroot_2048.cac -P $TEMP_DIR && \
wget http://dodpki.c3pki.chamb.disa.mil/dodeca.cac -P $TEMP_DIR && \
wget http://dodpki.c3pki.chamb.disa.mil/dodeca2.cac -P $TEMP_DIR && \
for n in $TEMP_DIR/*.cac; do certutil -d sql:$HOME/.pki/nssdb -A -t TC -n "$n" -i "$n"; done && \
for n in $TEMP_DIR/*.cac; do certutil -d sql:$HOME/.mozilla/firefox/*.default/ -A -t TC -n $n -i $n; done && \
rm -rf $TEMP_DIR
```
