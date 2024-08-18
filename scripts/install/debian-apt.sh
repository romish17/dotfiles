#!/usr/bin/env bash

################################################################
# 📜 Debian/ Ubuntu, apt Package Install / Update Script       #
################################################################

# Apps to be installed via apt-get
debian_apps=(
   # Système X et gestion de fenêtre
   'xserver-xorg-core'     # Composant central du serveur X, responsable de la gestion de l'affichage.
   'x11-xserver-utils'      # Ensemble d'utilitaires pour la configuration et le contrôle du serveur X.
   'psmisc'                 # Collection d'outils système, dont 'killall' pour gérer les processus.
   'compton'                # Compositeur de fenêtres pour ajouter des effets comme la transparence et les ombres.
   'jgmenu'                 # Menu léger pour le clic droit, souvent utilisé avec Openbox.

   # Gestionnaire de session et services de bureau
   'nitrogen'               # Outil pour définir des fonds d'écran sur les environnements de bureau.
   'dunst'                  # Gestionnaire de notifications léger et personnalisable.
   'tint2'                  # Barre des tâches et de notification légère.
   'picom'                  # Compositeur pour les effets visuels comme la transparence et les ombres (successeur de Compton).
   'xsettingsd'             # Démon léger pour gérer les paramètres X11, souvent utilisé pour GTK.
   'xss-lock'               # Utilitaire pour verrouiller l'écran après un certain temps d'inactivité.
   'unclutter'              # Outil pour cacher automatiquement le curseur de la souris lorsqu'il est inactif.
   'feh'                    # Visionneuse d'images rapide et simple, souvent utilisée pour gérer les fonds d'écran.
   'lxappearance'           # Outil pour configurer l'apparence des thèmes GTK et des icônes.
   'udiskie'                # Gestionnaire de périphériques de stockage, utile pour le montage automatique.
   'xfce4-power-manager'    # Gestionnaire de l'alimentation pour XFCE, utile pour gérer l'énergie sur des machines portables.

   # Audio
   'pulseaudio'             # Serveur de son qui permet la gestion de l'audio sur le système.
   'mpd'                    # Démon de lecture audio pour gérer et lire de la musique.
   'mpc'                    # Client léger pour interagir avec MPD via la ligne de commande.
   'ncmpcpp'                # Interface en ligne de commande pour MPD, très personnalisable.
   'pavucontrol'            # Interface graphique pour contrôler le volume de Pulseaudio.
   'alsa-utils'             # Outils pour gérer les périphériques audio via ALSA (Advanced Linux Sound Architecture).

   # Outils et utilitaires
   'brightnessctl'          # Utilitaire en ligne de commande pour contrôler la luminosité de l'écran.
   'imagemagick'            # Ensemble d'outils pour la manipulation d'images en ligne de commande.
   'scrot'                  # Outil de capture d'écran en ligne de commande.
   'w3m-img'                # Module de w3m pour afficher des images dans le terminal.
   'wireless-tools'         # Ensemble d'outils pour configurer et contrôler les connexions sans fil.
   'xclip'                  # Utilitaire en ligne de commande pour manipuler le presse-papiers X11.
   'parcellite'             # Gestionnaire de presse-papiers léger.
   'gsimplecal'             # Calendrier simple et léger pour la barre des tâches.
   'neofetch'               # Outil pour afficher des informations système de manière esthétique dans le terminal.
   'sudo'                   # Permet aux utilisateurs d'exécuter des commandes avec les privilèges d'un autre utilisateur.
   'python3-xdg'            # Implémentation Python des spécifications XDG (X Desktop Group).
   'btop'                   # Outil de surveillance des ressources système, successeur de bashtop.
   'htop'                   # Outil interactif en ligne de commande pour la surveillance des processus.
   'zsh'                    # Shell puissant et très personnalisable, souvent utilisé comme alternative à bash.
   'build-essential'        # Ensemble d'outils pour compiler des logiciels, incluant GCC, make, etc.
   'dkms'                   # Infrastructure pour construire et installer automatiquement des modules de noyau.
   'linux-headers-$(uname -r)' # En-têtes de noyau nécessaires pour compiler des modules du noyau.
   'aria2'                  # Utilitaire de téléchargement avec reprise de téléchargement (meilleur que wget).
   'bat'                    # Affichage avec syntaxe colorée (meilleur que cat).
   'broot'                  # Navigation interactive dans les répertoires.
   'ctags'                  # Indexation des informations de fichiers et des en-têtes.
   'diff-so-fancy'          # Comparaison de fichiers lisible (meilleur que diff).
   'duf'                    # Informations sur les disques montés (meilleur que df).
   'exa'                    # Liste les fichiers avec des informations (meilleur que ls).
   'fzf'                    # Trouve et filtre des fichiers de manière floue.
   'hyperfine'              # Benchmarking pour des commandes arbitraires.
   'just'                   # Exécution de commandes puissantes (meilleur que make).
   'jq'                     # Analyseur JSON, sortie et requêtes de fichiers.
   'most'                   # Pager multi-fenêtres (meilleur que less).
   'procs'                  # Visualiseur de processus avancé (meilleur que ps).
   'ripgrep'                # Recherche dans les fichiers (meilleur que grep).
   'sd'                     # Trouver et remplacer avec Regex (meilleur que sed).
   'thefuck'                # Correction automatique des commandes mal tapées.
   'tealdeer'               # Lecteur de documentation de commandes (meilleur que man).
   'tree'                   # Affichage des répertoires sous forme d'arborescence.
   'tokei'                  # Compte les lignes de code (meilleur que cloc).
   'trash-cli'              # Gestion des fichiers supprimés, restauration et enregistrement.
   'xsel'                   # Accès au presse-papiers X.
   'zoxide'                 # Navigation auto-apprise (meilleur que cd).

   # Applications
   'rofi'                   # Lanceur d'applications et menu texte, très personnalisable.
   'rxvt-unicode'           # Émulateur de terminal léger avec support des polices Unicode.
   'thunar'                 # Gestionnaire de fichiers léger pour XFCE.
   'thunar-archive-plugin'  # Plugin pour Thunar pour gérer les archives compressées.
   'thunar-volman'          # Plugin pour Thunar pour gérer automatiquement les périphériques amovibles.
   'ffmpegthumbnailer'      # Générateur de vignettes vidéo léger basé sur ffmpeg.
   'tumbler'                # Service de création de miniatures pour divers formats de fichiers.
   'geany'                  # Éditeur de texte léger avec des fonctionnalités IDE.
   'geany-plugins'          # Ensemble de plugins pour étendre les fonctionnalités de Geany.
   'gimp'                   # Éditeur d'images puissant et open-source.
   'inkscape'               # Logiciel de dessin vectoriel open-source.
   'mpv'                    # Lecteur multimédia léger et très configurable.
   'viewnior'               # Visionneuse d'images rapide et simple.
   'git'                    # Système de gestion de versions distribué.
   'neovim'                 # Éditeur de texte extensible et configurable.
   'ranger'                 # Navigateur de répertoires dans le terminal.
   'tmux'                   # Multiplexeur de terminaux.
   'wget'                   # Téléchargeur de fichiers via HTTP, HTTPS et FTP.
   'aria2'                  # Utilitaire de téléchargement avec reprise de téléchargement.
   'bat'                    # Affichage de fichiers avec syntaxe colorée.
   'broot'                  # Navigation interactive dans les répertoires.
   'ctags'                  # Indexation des informations de fichiers et des en-têtes.
   'diff-so-fancy'          # Comparaison de fichiers lisible.
   'duf'                    # Informations sur les disques montés.
   'exa'                    # Liste les fichiers avec des informations.
   'fzf'                    # Trouve et filtre des fichiers de manière floue.
   'hyperfine'              # Benchmarking pour des commandes.
   'just'                   # Exécution de commandes puissantes.
   'jq'                     # Analyseur JSON.
   'most'                   # Pager multi-fenêtres.
   'procs'                  # Visualiseur de processus avancé.
   'ripgrep'                # Recherche dans les fichiers.
   'sd'                     # Trouver et remplacer avec Regex.
   'thefuck'                # Correction automatique des commandes mal tapées.
   'tealdeer'               # Lecteur de documentation de commandes.
   'tree'                   # Affichage des répertoires sous forme d'arborescence.
   'tokei'                  # Compte les lignes de code.
   'trash-cli'              # Gestion des fichiers supprimés.
   'xsel'                   # Accès au presse-papiers X.
   'zoxide'                 # Navigation auto-apprise.
   'net-tools'              # For ifconfig

   # Sécurité
   'cryptsetup'             # Gestion des volumes cryptés.
   'gnupg'                  # Chiffrement PGP, signature et vérification.
   'git-crypt'              # Cryptage transparent pour les dépôts git.
   'lynis'                  # Analyse du système pour détecter des problèmes de sécurité.
   'openssl'                # Toolkit de cryptographie et SSL/TLS.
   'rkhunter'               # Détection de rootkits et d'autres menaces.

   # Monitoring, gestion et statistiques
   'btop'                   # Surveillance des ressources système.
   'bmon'                   # Moniteur d'utilisation de bande passante.
   'ctop'                   # Surveillance des conteneurs.
   'gping'                  # Outil interactif de ping avec graphique.
   'glances'                # Moniteur de ressources avec interface web et API.
   'goaccess'               # Analyseur et visualiseur de logs web.
   'speedtest-cli'          # Outil de test de vitesse de connexion en ligne de commande.

   # CLI Fun
   'cowsay'                 # Affiche des messages avec une vache ASCII.
   'figlet'                 # Affiche du texte en art ASCII 3D.
   'lolcat'                 # Sortie en couleur arc-en-ciel dans le terminal.
)


ubuntu_repos=(
  'main'
  'universe'
  'restricted'
  'multiverse'
)

debian_repos=(
  'main'
  'contrib'
  'non-free'
)

# Following packages not found by apt, need to fix:
# aria2, bat, broot, diff-so-fancy, duf, hyperfine,
# just, procs, ripgrep, sd, tealdeer, tokei, trash-cli,
# zoxide, clamav, cryptsetup, gnupg, lynis, btop, gping.

# Color variables
LIGHTGREEN='\033[1;32m'
YELLOW='\033[0;93m'
LIGHT='\033[2;32m'
CYAN_B='\033[1;96m'
RESET='\033[0m'

PROMPT_TIMEOUT=15 # When user is prompted for input, skip after x seconds

# If set to auto-yes - then don't wait for user reply
if [[ $* == *"--auto-yes"* ]]; then
  PROMPT_TIMEOUT=0
  REPLY='Y'
fi

# Print intro message
echo -e "${LIGHTGREEN}Starting Debian/ Ubuntu package install & update script"
echo -e "${YELLOW}Before proceeding, ensure your happy with all the packages listed in \e[4m${0##*/}"
echo -e "${RESET}"

# Check if running as root, and prompt for password if not
if [ "$EUID" -ne 0 ]; then
  echo -e "${LIGHTGREEN}Elevated permissions are required to adjust system settings."
  echo -e "${CYAN_B}Please enter your password...${RESET}"
  sudo -v
  if [ $? -eq 1 ]; then
    echo -e "${YELLOW}Exiting, as not being run as sudo${RESET}"
    exit 1
  fi
fi

# Check apt-get actually installed
if ! hash apt 2> /dev/null; then
  echo "${YELLOW_B}apt doesn't seem to be present on your system. Exiting...${RESET}"
  exit 1
fi

# Enable upstream package repositories
echo -e "${CYAN_B}Would you like to enable listed repos? (y/N)${RESET}\n"
read -t $PROMPT_TIMEOUT -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  if ! hash add-apt-repository 2> /dev/null; then
    sudo apt install --reinstall software-properties-common
  fi
  # If Ubuntu, add Ubuntu repos
  if lsb_release -a 2>/dev/null | grep -q 'Ubuntu'; then
    for repo in ${ubuntu_repos[@]}; do
      echo -e "${LIGHTGREEN}Enabling ${repo} repo...${RESET}"
      sudo add-apt-repository $repo
    done
  else
    # Otherwise, add Debian repos
    for repo in ${debian_repos[@]}; do
      echo -e "${LIGHTGREEN}Enabling ${repo} repo...${RESET}"
      sudo add-apt-repository $repo
    done
  fi
fi

# Prompt user to update package database
echo -e "${CYAN_B}Would you like to update package database? (y/N)${RESET}\n"
read -t $PROMPT_TIMEOUT -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo -e "${LIGHTGREEN}Updating database...${RESET}"
  sudo apt update
fi

# Prompt user to upgrade currently installed packages
echo -e "${CYAN_B}Would you like to upgrade currently installed packages? (y/N)${RESET}\n"
read -t $PROMPT_TIMEOUT -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo -e "${LIGHTGREEN}Upgrading installed packages...${RESET}"
  sudo apt upgrade
fi

# Prompt user to clear old package caches
echo -e "${CYAN_B}Would you like to clear unused package caches? (y/N)${RESET}\n"
read -t $PROMPT_TIMEOUT -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo -e "${LIGHTGREEN}Freeing up disk space...${RESET}"
  sudo apt autoclean
fi

# Prompt user to install all listed apps
echo -e "${CYAN_B}Would you like to install listed apps? (y/N)${RESET}\n"
read -t $PROMPT_TIMEOUT -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo -e "${LIGHTGREEN}Starting install...${RESET}"
  for app in ${debian_apps[@]}; do
    if hash "${app}" 2> /dev/null; then
      echo -e "${YELLOW}[Skipping]${LIGHT} ${app} is already installed${RESET}"
    elif hash flatpak 2> /dev/null && [[ ! -z $(echo $(flatpak list --columns=ref | grep $app)) ]]; then
      echo -e "${YELLOW}[Skipping]${LIGHT} ${app} is already installed via Flatpak${RESET}"
    else
      echo -e "${LIGHTGREEN}[Installing]${LIGHT} Downloading ${app}...${RESET}"
      sudo apt install ${app} --assume-yes
    fi
  done
fi

echo -e "${LIGHTGREEN}Finished installing / updating Debian packages.${RESET}"

# EOF
