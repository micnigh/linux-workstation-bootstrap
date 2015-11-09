#!/bin/bash

# st3 - install theme
mkdir -p $HOME/.config/sublime-text-3/Packages/
cd $HOME/.config/sublime-text-3/Packages/
git clone https://github.com/Miw0/sodareloaded-theme/ "Theme - SoDaReloaded"

# st3 - Package manager
mkdir -p $HOME/.config/sublime-text-3/Installed\ Packages
curl \
  -o $HOME/.config/sublime-text-3/Installed\ Packages/Package\ Control.sublime-package \
  --remote-name http://sublime.wbond.net/Package%20Control.sublime-package

curl \
  -o $HOME/.config/sublime-text-3/Packages/User/Preferences.sublime-settings \
  --remote-name https://raw.githubusercontent.com/micnigh/linux-workstation-bootstrap/master/files/.config/sublime-text-3/Packages/User/Preferences.sublime-settings

# solarized terminal
sh -c 'curl -sSL https://raw.githubusercontent.com/chriskempson/base16-gnome-terminal/master/base16-solarized.dark.sh | bash'; # setup
gconftool-2 --set --type string /apps/gnome-terminal/global/default_profile base-16-solarized-dark

# apm packages
apm install \
  minimap \
    minimap-git-diff \
    minimap-find-and-replace \
    minimap-selection \
    minimap-pigments \
  linter \
    linter-eslint \
    linter-htmlhint \
    linter-less \
    linter-scss-lint \
  pigments \
  line-ending-converter \
  git-plus \
  merge-conflicts \
  language-docker \
  language-babel \
  file-type-icons \
  file-icons \
  tabs-to-spaces \
  Sublime-Style-Column-Selection \
  color-picker \
  editorconfig \
  imdone-atom

# npm config
# use user path, not install path
npm config set prefix '~/npm/'

case "$(lsb_release -si)" in
	Ubuntu)
		case "$DESKTOP_SESSION" in
      ubuntu)
        sh -c 'curl -sSL https://raw.githubusercontent.com/micnigh/linux-workstation-bootstrap/master/scripts/distro/ubuntu-based/ubuntu-unity/setup-user-profile.sh | bash';
      ;;
    esac
	;;
  LinuxMint)
    case "$DESKTOP_SESSION" in
      cinnamon)
        sh -c 'curl -sSL https://raw.githubusercontent.com/micnigh/linux-workstation-bootstrap/master/scripts/distro/ubuntu-based/linux-mint-cinnamon/setup-user-profile.sh | bash';
      ;;
    esac
  ;;
esac
