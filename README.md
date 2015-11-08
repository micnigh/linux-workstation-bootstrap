Bootstrap guide for new linux Mint 17.2 Cinnamon workstation setup.

# Quick start

```bash

sudo sh -c 'curl -sSL https://raw.githubusercontent.com/micnigh/linux-mint-17-2-cinnamon-workstation-bootstrap/master/scripts/install-packages.sh | bash'; # install all packages
sh -c 'curl -sSL https://raw.githubusercontent.com/micnigh/linux-mint-17-2-cinnamon-workstation-bootstrap/master/scripts/setup-user-profile.sh | bash'; # setup user profile

# install ssh keys, then fix permissions
chmod 600 ~/.ssh/
chmod 600 ~/.ssh/id_rsa*

# run dropbox setup, then apply fix for transparency of icon
# for some reason dropbox ships their own libGL :(
# https://www.dropboxforum.com/hc/en-us/community/posts/201269689-tray-icon-linux
# TODO: remove when no longer needed
mv ~/.dropbox-dist/dropbox-lnx.x86_64*/libGL.so.1 libGL.so.1.bak

# add dotfiles from git bash
# From [micnigh/linux-dotfiles](https://github.com/micnigh/linux-dotfiles)
cd ~/
git init .
git remote add origin https://github.com/micnigh/linux-dotfiles.git
git fetch --all
git reset --hard origin/master

```
