#!/usr/bin/env bash

sudo apt update && apt upgrade -yy
sudo apt install xorg bspwm sxhkd polybar compton rofi dunst nitrogen i3lock redshift cmus ranger kitty alacritty thunar -yy

# bspwm conf
# sxhkdrc conf
# polybar conf
# compton conf
# nanorc conf
# btop conf
# htop conf

cd ~/.config/ && mkdir -p bspwm sxhkd polybar
cp /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/
cp /usr/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd/
sudo chmod u+x ~/.config/bspwm/bspwmrc

