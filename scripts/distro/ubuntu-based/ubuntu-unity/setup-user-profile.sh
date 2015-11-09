#!/bin/bash

# disable online search lenses - http://askubuntu.com/a/629255
gsettings set com.canonical.Unity.Lenses remote-content-search 'none'

# add calc to default search - http://askubuntu.com/a/594161, http://discourse.ubuntu.com/t/improve-unity-offline-scopes-performance/1202/6
gsettings set com.canonical.Unity.Lenses always-search "['applications.scope', 'info-calculator.scope', 'music.scope', 'videos.scope', 'files.scope']"

# enable virtual desktops
gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ hsize 2
gsettings set org.compiz.core:/org/compiz/profiles/unity/plugins/core/ vsize 2
