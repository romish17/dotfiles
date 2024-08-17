#!/usr/bin/env bash

################################################################
# 📜 Openbox Install Script                                    #
################################################################

# Download assets

#wget https://github.com/romish17/install/raw/main/custom/themes/Nordic-master.zip
#wget https://github.com/romish17/install/raw/main/custom/icons/Nordzy.tar.gz
#wget https://github.com/romish17/install/raw/main/custom/icons/Nordzy-dark.tar.gz

#unzip Nordic-master.zip -d /tmp/
#tar -xzvf Nordzy.tar.gz -C /tmp/
#tar -xzvf Nordzy-dark.tar.gz -C /tmp/

#sudo mv -r /tmp/Nordic-master/gtk-3.0 /usr/share/themes/Nordic
#sudo mv /tmp/Nordzy /usr/share/icons/Nordzy
#sudo mv /tmp/Nordzy-dark /usr/share/icons/Nordzy-dark

# Fonction pour afficher un message d'erreur et quitter
function error_exit {
    echo "$1" 1>&2
    exit 1
}

# Fonction pour télécharger un fichier
function download_file {
    local url=$1
    local output=$2
    echo "Téléchargement de $url..."
    curl -s -o "$output" "$url" || error_exit "Échec du téléchargement de $url."
}

# Variables
THEME_NAME="Nordic"
ICONS_NAME="Nordzy"
ICONS_URL="https://github.com/romish17/install/raw/main/custom/icons/Nordzy.tar.gz"
ICONS_PATH="/usr/share/icons/Nordzy"
THEME_URL="https://github.com/romish17/install/raw/main/custom/themes/Nordic-master.zip"
THEME_PATH="/usr/share/themes/Nordic"
WALLPAPER_URL="https://example.com/monfond.jpg"  # Remplacez par l'URL du fond d'écran
WALLPAPER_PATH="$HOME/Pictures/monfond.jpg"

# Chemins pour les fichiers de configuration
OPENBOX_THEME_PATH="$HOME/.themes/$THEME_NAME"
ICON_THEME_PATH="$HOME/.icons/$ICONS_NAME"
OPENBOX_CONFIG_PATH="$HOME/.config/openbox/rc.xml"

# Changement de thème Openbox
echo "Changement du thème Openbox en $THEME_NAME..."
if [ -d "$OPENBOX_THEME_PATH" ]; then
    # Appliquer le thème en modifiant le fichier de configuration d'Openbox
    sed -i "s/^<theme>.*<\/theme>/<theme>$THEME_NAME<\/theme>/" "$OPENBOX_CONFIG_PATH" || error_exit "Erreur lors de la modification du thème dans $OPENBOX_CONFIG_PATH."
else
    error_exit "Le thème Openbox '$THEME_NAME' n'existe pas dans $OPENBOX_THEME_PATH."
fi

# Changement du pack d'icônes
echo "Changement du pack d'icônes en $ICONS_NAME..."
if [ -d "$ICON_THEME_PATH" ]; then
    # Appliquer le pack d'icônes
    gsettings set org.gnome.desktop.interface icon-theme "$ICONS_NAME" || error_exit "Erreur lors du changement du pack d'icônes en $ICONS_NAME."
else
    error_exit "Le pack d'icônes '$ICONS_NAME' n'existe pas dans $ICON_THEME_PATH."
fi

# Téléchargement et application du fond d'écran
download_file "$WALLPAPER_URL" "$WALLPAPER_PATH"

echo "Changement du fond d'écran..."
feh --bg-scale "$WALLPAPER_PATH" || error_exit "Erreur lors de la configuration du fond d'écran."

# Redémarrage d'Openbox pour appliquer les changements
echo "Redémarrage d'Openbox pour appliquer les changements..."
openbox --reconfigure || error_exit "Erreur lors du redémarrage d'Openbox."

echo "Changements appliqués avec succès."
