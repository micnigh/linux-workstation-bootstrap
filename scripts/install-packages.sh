#!/bin/bash

case "$(lsb_release -si)" in
	Ubuntu|LinuxMint)
    sudo sh -c 'curl -sSL https://raw.githubusercontent.com/micnigh/linux-workstation-bootstrap/master/scripts/distro/ubuntu-based/install-packages.sh | bash';
	;;
esac
