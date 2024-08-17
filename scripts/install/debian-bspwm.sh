#!/usr/bin/env bash

sudo apt update && apt upgrade -yy
sudo apt install xorg bspwm sxhkd polybar compton rofi dunst nitrogen i3lock redshift cmus ranger kitty alacritty thunar unzip -yy

# bspwm conf -> ok
# sxhkdrc conf -> ok
# polybar conf -> ok
# compton conf -> ok
# nanorc conf
# btop conf
# htop conf
# theme
# fonts
# icons

mkdir -p ~/.config/{bspwm,sxhkd,polybar,compton}
cp ../linux/dotfiles/bspwm/bspwmrc ~/.config/bspwm/
cp ../linux/dotfiles/sxhkd/sxhkdrc ~/.config/sxhkd/
cp ../linux/dotfiles/polybar/config.ini ~/.config/polybar/
cp ../linux/dotfiles/compton.conf ~/.config/compton/compton.conf

cp -r ../../custom/wallpapers/ ~/.config/wallpapers/
tar -xzf ../../custom/icons/Nordzy.tar.gz -C /usr/share/icons/Nordzy/
unzip ../../custom/themes/Nordic-master.zip -d /usr/share/themes/Nordic/
sudo chmod u+x ~/.config/bspwm/bspwmrc

# A modifier plus tard
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip \
&& cd ~/.local/share/fonts \
&& unzip JetBrainsMono.zip \
&& rm JetBrainsMono.zip \
&& fc-cache -fv

