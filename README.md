Bootstrap guide for new linux workstation setup.

Supports

 - Mint 17.2 Cinnamon
 - Ubuntu unity 15.10.

# Quick start

```bash

# manually do all upgrades/updates and install drivers
sudo apt-get update;
sudo apt-get -y upgrade;
sudo apt-get -y dist-upgrade;

# need curl to run scripts
sudo apt-get install -y curl;

# install packages
sudo -E sh -c 'curl -sSL https://raw.githubusercontent.com/micnigh/linux-workstation-bootstrap/master/scripts/install-packages.sh | bash';

# setup user profile
sh -c 'curl -sSL https://raw.githubusercontent.com/micnigh/linux-workstation-bootstrap/master/scripts/setup-user-profile.sh | bash';

# install ssh keys, then fix permissions
ssh-keygen -f ~/.ssh/id_rsa -t rsa -N '' -C 'email@email.com'
chmod 700 ~/.ssh/
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

#### Add smb network folder

```bash
sudo apt-get install -y cifs-utils
```

Create a file `/home/ubuntuuser/.smbcredentials` containing below

```
username=
password=
```

Fix the permissions so only ubuntuuser can read it

```bash
chmod 600 /home/ubuntuuser/.smbcredentials
chown ubuntuuser:ubuntuuser /home/ubuntuuser/.smbcredentials
```

Append share info to /etc/fstab/

```
//servername/sharename  /media/windowsshare  cifs   uid=ubuntuuser,credentials=/home/ubuntuuser/.smbcredentials,iocharset=utf8,sec=ntlm   0       0
```

Test that it works

```bash
sudo mount -a
```

#### Add DOD ssl certs

Add dod certs from https://militarycac.com/maccerts/ and http://dodpki.c3pki.chamb.disa.mil/rootca.html

##### Install into user account (firefox, chrome, thunderbird)

```bash
sudo apt-get -y install libnss3-tools

TEMP_DIR=$(mktemp -d)
wget --no-check-certificate https://militarycac.com/maccerts/AllCerts.zip -P $TEMP_DIR
unzip -d $TEMP_DIR $TEMP_DIR/AllCerts.zip
wget http://dodpki.c3pki.chamb.disa.mil/rel3_dodroot_2048.cac -P $TEMP_DIR
wget http://dodpki.c3pki.chamb.disa.mil/dodeca.cac -P $TEMP_DIR
wget http://dodpki.c3pki.chamb.disa.mil/dodeca2.cac -P $TEMP_DIR
for f in $TEMP_DIR/*.cer; do mv "$f" "${f// /_}"; done
for certDB in $(find ~/.mozilla* ~/.thunderbird ~/.pki -name "cert*.db" 2>/dev/null)
do
  certDBDir=$(dirname $certDB)
  echo "installing certs to db in $certDBDir"
  for cert in $TEMP_DIR/{*.cer,*.cac}
  do
    echo "$cert"
    # install to new format, `cert9.db, key4.db`
    certutil -d sql:$certDBDir -A -t "TC" -n "$(basename $cert)" -i "$cert"
    # install to old format, `cert8.db, key3.db`
    certutil -d $certDBDir -A -t "TC" -n "$(basename $cert)" -i "$cert"
  done
done

# test certs installed with
# certutil -L -d ~/.mozilla/firefox/*.default/
```

##### Install globally into root certificate store

```bash
sudo su

TEMP_DIR=$(mktemp -d) && \
wget --no-check-certificate https://militarycac.com/maccerts/AllCerts.zip -P $TEMP_DIR && \
unzip -d $TEMP_DIR $TEMP_DIR/AllCerts.zip && \
for f in $TEMP_DIR/*.cer; do mv "$f" "${f%.cer}.crt"; done && \
for f in $TEMP_DIR/*.crt; do mv "$f" "${f// /_}"; done && \
mkdir -p /usr/share/ca-certificates/dod/ && \
cp $TEMP_DIR/*.crt /usr/share/ca-certificates/dod/ && \
rm -rf $TEMP_DIR && \
dpkg-reconfigure ca-certificates
```

#### Docker DNS Issues

Docker sometimes cannot detect dns settings, lookup what's in `Connection Information` on the up/down arrow icon in the system tray and the `search` field in /etc/resolv.conf.  Then modify `/etc/default/docker` line `DOCKER_OPTs` to include something like

```bash
DOCKER_OPTS="--dns=172.20.20.12 --dns=172.20.20.11 --dns-search=ern.nps.edu"
```

On Ubuntu 15.10 - the env file is not automatically applied, but we can fix that by running below (copied and modified from `/lib/systemd/system/docker.service` from https://github.com/docker/docker/issues/9889#issuecomment-120927382)

```bash
sudo tee /etc/systemd/system/docker.service << "EOF"
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network.target docker.socket
Requires=docker.socket

[Service]
EnvironmentFile=-/etc/default/docker
Type=notify
ExecStart=/usr/bin/docker daemon $DOCKER_OPTS -H fd://
MountFlags=slave
LimitNOFILE=1048576
LimitNPROC=1048576
LimitCORE=infinity

[Install]
WantedBy=multi-user.target

EOF
```

then redetect changes `systemctl daemon-reload` and `sudo service docker restart` to apply

#### Cisco anyconnect VPN

```bash
# download encryption libs
sudo apt-get install -y lib32z1 lib32ncurses5

# download then run `vpnsetup.sh` cisco anyconnect script for linux
sudo sh vpnsetup.sh

# restart vpn service
sudo systemctl daemon-reload
```
