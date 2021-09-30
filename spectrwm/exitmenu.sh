#!/bin/bash

. $HOME/.config/dmenu/.dmenurc
DMENU="dmenu $DMENU_OPTIONS"
choice=$(echo -e "shutdown\nreboot\nsuspend" | $DMENU)

case "$choice" in
				shutdown) shutdown -h now & ;;
				reboot) shutdown -r now & ;;
				suspend) systemctl suspend & ;;
esac
