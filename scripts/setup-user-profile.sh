#!/bin/bash

case "$(lsb_release -si)" in
	Ubuntu|LinuxMint)
    sh -c 'curl -sSL https://raw.githubusercontent.com/micnigh/linux-workstation-bootstrap/master/scripts/distro/ubuntu-based/setup-user-profile.sh | bash';
	;;
esac
