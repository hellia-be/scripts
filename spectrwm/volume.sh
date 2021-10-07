#!/bin/bash

case $1 in 
				mute) pactl set-sink-mute @DEFAULT_SINK@ toggle && notify-send "Volume toggled" ;;
				up) pactl set-sink-volume @DEFAULT_SINK@ +5% && notify-send "Volume up" ;;
				down) pactl set-sink-volume @DEFAULT_SINK@ -5% && notify-send "Volume down" ;;
				*) exit 1 ;;
esac
