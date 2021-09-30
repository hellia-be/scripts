#!/bin/bash

start-pulseaudio-x11 &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
xfce4-power-manager &
nitrogen --restore &
dunst &
