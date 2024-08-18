#!/usr/bin/env bash

# Add contrib & non-free repos
sed -i 's/^deb \(\S*\) \(.*\) main/deb \1 \2 main contrib non-free/' /etc/apt/sources.list

sudo apt update && apt upgrade -yy
sudo apt install xorg bspwm sxhkd polybar compton rofi dunst nitrogen i3lock redshift cmus ranger kitty alacritty thunar unzip psmisc pulseaudio -yy

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
sudo mkdir -p /usr/share/icons/Nordzy/ && sudo tar -xzf ../../custom/icons/Nordzy.tar.gz && sudo cp -r Nordzy/ /usr/share/icons/Nordzy/
unzip ../../custom/themes/Nordic-master.zip
sudo cp -r Nordic-master/ /usr/share/themes/Nordic/
sudo rm -r Nordic-master/
sudo chmod u+x ~/.config/bspwm/bspwmrc

# A modifier plus tard
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip \
&& cd ~/.local/share/fonts \
&& unzip JetBrainsMono.zip \
&& rm JetBrainsMono.zip \
&& fc-cache -fv

