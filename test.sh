#!/bin/bash

case "$(lsb_release -si)" in
	Ubuntu)
		case "$DESKTOP_SESSION" in
      ubuntu)
        
      ;;
    esac
	;;
  LinuxMint)
    case "$DESKTOP_SESSION" in
      cinnamon)

      ;;
    esac
  ;;
esac
