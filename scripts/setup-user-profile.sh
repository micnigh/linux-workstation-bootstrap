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
  --remote-name https://raw.githubusercontent.com/micnigh/linux-mint-17-2-cinnamon-workstation-bootstrap/master/files/.config/sublime-text-3/Packages/User/Preferences.sublime-settings

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
