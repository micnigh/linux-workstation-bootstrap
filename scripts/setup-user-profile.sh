#!/bin/bash

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
