#!/usr/bin/env bash

./color.sh
# Add contrib & non-free repos
echo -e "${LIGHTGREEN}[Installing]${LIGHT} Ajout des dépôts contrib et non-free...${RESET}"
sed -i 's/^deb \(\S*\) \(.*\) main/deb \1 \2 main contrib non-free/' /etc/apt/sources.list 2> /dev/null

sudo apt update && apt upgrade -yy 2> /dev/null

debian_apps=(
    xorg
    bspwm
    sxhkd
    polybar
    compton
    rofi
    dunst
    nitrogen
    i3lock
    redshift
    cmus
    ranger
    kitty
    alacritty
    thunar
    unzip
    psmisc
    pulseaudio
)

for app in ${debian_apps[@]}; do
    if hash "${app}" 2> /dev/null; then
      echo -e "${YELLOW}[Skipping]${LIGHT} ${app} is already installed${RESET}"
    elif hash flatpak 2> /dev/null && [[ ! -z $(echo $(flatpak list --columns=ref | grep $app)) ]]; then
      echo -e "${YELLOW}[Skipping]${LIGHT} ${app} is already installed via Flatpak${RESET}"
    else
      echo -e "${LIGHTGREEN}[Installing]${LIGHT} Downloading ${app}...${RESET}"
      sudo apt install ${app} --assume-yes 2> /dev/null
    fi


echo -e "${LIGHTGREEN}[Installing]${LIGHT} Copy theme files...${RESET}"

#mkdir -p ~/.config/{bspwm,sxhkd,polybar,compton,gtk-3.0}
#cp ../linux/dotfiles/bspwm/bspwmrc ~/.config/bspwm/
#cp ../linux/dotfiles/sxhkd/sxhkdrc ~/.config/sxhkd/
#cp ../linux/dotfiles/polybar/config.ini ~/.config/polybar/
#cp ../linux/dotfiles/compton/compton.conf ~/.config/compton/compton.conf
#cp ../linux/dotfiles/gtk-3.0/settings.ini ~/.config/gtk-3.0/settings.ini
#cp ../linux/dotfiles/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml
cp -r ../../custom/wallpapers/ ~/.config/wallpapers/
cp -r ../linux/dotfiles/ ~/.config/

sudo tar -xzf ../../custom/icons/Nordzy.tar.gz && sudo cp -r Nordzy/ /usr/share/icons/
unzip ../../custom/themes/Nordic-master.zip
sudo cp -r Nordic-master/ /usr/share/themes/Nordic/
sudo cp -r ../../custom/fonts/*.ttf ~/.local/share/fonts/
sudo rm -r Nordic-master/
sudo chmod u+x ~/.config/bspwm/bspwmrc

# A modifier plus tard
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip \
&& cd ~/.local/share/fonts \
&& unzip JetBrainsMono.zip \
&& rm JetBrainsMono.zip \
&& fc-cache -fv