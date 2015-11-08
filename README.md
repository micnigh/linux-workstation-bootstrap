Bootstrap guide for new linux Mint 17.2 Cinnamon workstation setup.

```bash

# Use fastest mirror
sudo sed -i 's/archive\.ubuntu\.com/mirrors.us.kernel.org/' /etc/apt/sources.list.d/official-package-repositories.list

sudo apt-get update
sudo apt-get install -y curl

#
# Setup PPAs
#
sudo add-apt-repository -y ppa:webupd8team/sublime-text-3; # sublime text 3
sudo add-apt-repository -y ppa:chris-lea/node.js;          # nodejs

sudo add-apt-repository -y ppa:webupd8team/atom; # atom
sudo add-apt-repository -y ppa:nilarimogard/webupd8; # android tools

# chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

# docker
sudo sh -c "curl http://get.docker.io/gpg | apt-key add -"
sudo sh -c "echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"

# dropbox
sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E
echo 'deb http://linux.dropbox.com/ubuntu trusty main' | sudo tee /etc/apt/sources.list.d/dropbox.list

sudo apt-get update;
sudo apt-get upgrade -y;
sudo apt-get dist-upgrade -y;
sudo apt-get autoremove -y;

#
# Install Packages
#
# split up by category, otherwise the update may crash due to resolving too many packages :( - TODO: check if this is still true...
#

PACKAGES=(

  # system|dev tools
  dkms                      # auto recompile drivers | modules on kernel update
  linux-headers-`uname -r`  # required for certain drivers | modules
  build-essential           # dev tools
  gcc                       # dev tools
  make                      # dev tools
  git                       # awesome version control
  subversion                # good version control

); sudo apt-get install -y --force-yes -o Dpkg::Options::="--force-overwrite" "${PACKAGES[@]}"; unset PACKAGES

PACKAGES=(

  # network
  curl                      # download and pipe to other tools - makes for easy web installers or tests
  wget                      # cli download tool
  samba                     # allows hostname to be seen by windows
  openssh-server            # allow ssh to this machine

); sudo apt-get install -y --force-yes -o Dpkg::Options::="--force-overwrite" "${PACKAGES[@]}"; unset PACKAGES

PACKAGES=(

  # programming lang|tools
  nodejs                    # Javascript v8 server engine
  lxc-docker                # Docker - virtual apps in containers using LXC
  apparmor                  # Required for docker, but not as a dep - see http://stackoverflow.com/a/23572617

); sudo apt-get install -y --force-yes -o Dpkg::Options::="--force-overwrite" "${PACKAGES[@]}"; unset PACKAGES

PACKAGES=(

  # misc
  python-gpgme # dropbox support lib
  gtk-redshift # redshift - adjusts displays to minimize blue light at night

  android-tools-adb      # android adb
  android-tools-fastboot # android fastboot

); sudo apt-get install -y --force-yes -o Dpkg::Options::="--force-overwrite" "${PACKAGES[@]}"; unset PACKAGES

# set answers to package prompts
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections;
PACKAGES=(

  # fonts
  ttf-mscorefonts-installer # ms fonts
  texlive-fonts-recommended # helvetica like fonts

); sudo apt-get install -y --force-yes -o Dpkg::Options::="--force-overwrite" "${PACKAGES[@]}"; unset PACKAGES

PACKAGES=(

  # utils
  vim                       # good cli text editor
  htop                      # good pretty cli system monitor
  time                      # make sure we have time util and not the simpler bash function
  rsync                     # sync files between machines
  renameutils               # for the qmv util - great when combined with sublime text
  zsh                       # awesome bash replacement when combined with .oh-my-zsh
  autojump                  # faster switching to project dirs
  xbindkeys                 # create keyboard shortcuts
  xclip                     # set clipboard from scripts

); sudo apt-get install -y --force-yes -o Dpkg::Options::="--force-overwrite" "${PACKAGES[@]}"; unset PACKAGES

PACKAGES=(

  # gui apps
  filezilla                 # (s)ftp files to server
  firefox                   # browser
  gimp                      # decent image editor
  sublime-text-installer    # sublime text 3
  google-chrome-stable      # chrome
  dropbox                   # dropbox
  atom                      # atom
  shutter                   # a very good screenshot|annotation app

); sudo apt-get install -y --force-yes -o Dpkg::Options::="--force-overwrite" "${PACKAGES[@]}"; unset PACKAGES

# symbolic links for programs
sudo ln -s /usr/bin/subl /usr/bin/sublime-text

# set default shell to zsh for root
sudo chsh -s /usr/bin/zsh

#
# System Configuration
#

# Up the inotify limits to reasonable values for a dev machine
cat <<EOF | sudo tee -a /etc/sysctl.d/90-raise-inotify-limits.conf
fs.inotify.max_user_instances   = 2048    # default 128,    max number of inotify instances per user
fs.inotify.max_user_watches     = 1048576 # default 524288, max number of file watches per user
EOF
echo 2048    | sudo tee /proc/sys/fs/inotify/max_user_instances
echo 1048576 | sudo tee /proc/sys/fs/inotify/max_user_watches

# install powerline fonts - fontconfig version - adds symbols rather than patching fonts
sudo wget -O /etc/fonts/conf.d/10-powerline-symbols.conf https://raw.github.com/Lokaltog/powerline/develop/font/10-powerline-symbols.conf
sudo wget -O /usr/share/fonts/PowerlineSymbols.otf https://raw.github.com/Lokaltog/powerline/develop/font/PowerlineSymbols.otf
sudo dpkg-reconfigure fontconfig
sudo fc-cache -rfv

# allow ipv4 to docker containers
sudo sed -i 's/^#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf

# allow ufw forwading for docker (allows us to access docker machines from other hosts)
sudo sed -i 's/^DEFAULT_FORWARD_POLICY="DROP"/DEFAULT_FORWARD_POLICY="ACCEPT"/' /etc/default/ufw
sudo ufw allow 4243/tcp
sudo ufw reload

```
