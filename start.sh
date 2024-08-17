#!/bin/bash

# Codes couleur
LIGHT_BLUE="\033[1;36m"
YELLOW="\033[1;33m"
WHITE="\033[1;37m"
LIGHT_GRAY="\033[0;37m"
RESET="\033[0m"

# https://raw.githubusercontent.com/romish17/dotfiles/main/prerequisites.sh

GITHUB_USER=romish17
GITHUB_REPOS=dotfiles

# Affichage du menu avec couleurs et numéros en lettres
echo -e ""
echo -e "${LIGHT_BLUE}░▒▓███████▓▒░   ░▒▓██████▓▒░  ░▒▓██████████████▓▒░  ░▒▓█▓▒░  ░▒▓███████▓▒░ ░▒▓█▓▒░░▒▓█▓▒░${RESET}"
echo -e "${LIGHT_BLUE}░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░ ░▒▓█▓▒░        ░▒▓█▓▒░░▒▓█▓▒░${RESET}"
echo -e "${LIGHT_BLUE}░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░ ░▒▓█▓▒░        ░▒▓█▓▒░░▒▓█▓▒░ ${RESET}" 
echo -e "${LIGHT_BLUE}░▒▓███████▓▒░  ░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░  ░▒▓██████▓▒░  ░▒▓████████▓▒░${RESET}"
echo -e "${LIGHT_BLUE}░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░        ░▒▓█▓▒░ ░▒▓█▓▒░░▒▓█▓▒░${RESET}" 
echo -e "${LIGHT_BLUE}░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░        ░▒▓█▓▒░ ░▒▓█▓▒░░▒▓█▓▒░${RESET}" 
echo -e "${LIGHT_BLUE}░▒▓█▓▒░░▒▓█▓▒░  ░▒▓██████▓▒░  ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░ ░▒▓███████▓▒░  ░▒▓█▓▒░░▒▓█▓▒░${RESET}" 
echo ""
echo -e "${WHITE}[1]${RESET} - 🌍 Installation serveur Debian"
echo -e "${LIGHT_GRAY}         (Docker, hadening conf SSH, neofetch, etc....)${RESET}"
echo -e "${WHITE}[2]${RESET} - 🪟 Configurer BSPWM"
echo -e "${WHITE}[3]${RESET} - 📦 Configurer Openbox"
echo -e "${WHITE}[4]${RESET} - 🚪 Quitter"
echo ""

# Lecture du choix de l'utilisateur
read -p "Veuillez choisir une option [1-4]: " choice

# Traitement du choix
case $choice in
    1)
        echo -e "${YELLOW}🌍 Installation serveur...${RESET}"
        #./scripts/install/debian-srv.sh
        ;;
    2)
        echo -e "${YELLOW}🪟 Installation de l'environnement BSPWM${RESET}"
        https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPOS/main/prerequisites.sh
        ;;
    3)
        echo -e "${YELLOW}📦 Installation de l'environnement Openbox${RESET}"
        #./scripts/install/debian-openbox.sh
        ;;
    4)
        echo -e "${YELLOW}🚪 Quitter${RESET}"
        exit 0
        ;;
    *)
        echo -e "${RED}❌ Option invalide, veuillez réessayer.${RESET}"
        ;;
esac
