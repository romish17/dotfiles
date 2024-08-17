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

mkdir -p ~/.config/{bspwm,sxhkd,polybar}
cp ../linux/dotfiles/bspwm/bspwmrc ~/.config/bspwm/
cp ../linux/dotfiles/sxhkd/sxhkdrc ~/.config/sxhkd/
cp ../linux/dotfiles/polybar/polybar.ini ~/.config/polybar/
sudo chmod u+x ~/.config/bspwm/bspwmrc

