Bootstrap guide for new linux Mint 17.2 Cinnamon workstation setup.

# Quick start

```bash

sudo sh -c 'curl -sSL https://raw.githubusercontent.com/micnigh/linux-mint-17-2-cinnamon-workstation-bootstrap/master/scripts/install-packages.sh | sh'; # install all packages
sh -c 'curl -sSL https://raw.githubusercontent.com/micnigh/linux-mint-17-2-cinnamon-workstation-bootstrap/master/scripts/setup-user-profile.sh | sh'; # setup user profile

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

```
