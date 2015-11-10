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

# setup git user
git config --global user.email ""
git config --global user.name ""

```

## Extra setup notes

### Linux mint 17.2

```bash
# run dropbox setup, then apply fix for transparency of icon
# for some reason dropbox ships their own libGL :(
# https://www.dropboxforum.com/hc/en-us/community/posts/201269689-tray-icon-linux
# TODO: remove when no longer needed
mv ~/.dropbox-dist/dropbox-lnx.x86_64*/libGL.so.1 libGL.so.1.bak
```
