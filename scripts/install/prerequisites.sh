#!/usr/bin/env bash

######################################################################
# Core Dependency Install Script                                     #
######################################################################

# Color variables
LIGHTGREEN='\033[1;32m'
YELLOW='\033[0;93m'
RED='\033[0;31m'
LIGHT='\033[2;32m'
RESET='\033[0m'

if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}You are not root.\n"\
    "Please start this script with root privileges.${RESET}"
    exit 1
fi

# List of apps to install
core_packages=(
  'git' # Needed to fetch dotfiles
  'nano' # Needed to edit files
  'zsh' # Needed as bash is crap
  'curl'
  'sudo'
)

# Shows help menu / introduction
function print_usage () {
  echo -e "${LIGHTGREEN}Prerequisite Dependency Installation Script${LIGHT}\n"\
  "This script will detect distro and use appropriate package manager to install apps.\n"\
  "Elavated permissions may be required. Ensure you've read the script before proceeding."\
  "\n${RESET}"
}

function install_debian () {
  echo -e "${LIGHTGREEN}Installing ${1} via apt-get${RESET}"
  apt install $1 -yy -qq > /dev/null 2>&1
}
function install_arch () {
  echo -e "${LIGHTGREEN}Installing ${1} via Pacman${RESET}"
  sudo pacman -S $1
}
function install_mac () {
  echo -e "${LIGHTGREEN}Installing ${1} via Homebrew${RESET}"
  brew install $1
}
function get_homebrew () {
  echo -e "${LIGHTGREEN}Setting up Homebrew${RESET}"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  export PATH=/opt/homebrew/bin:$PATH
}

# Detect OS type, then triggers install using appropriate package manager
function multi_system_install () {
  app=$1
  if [ "$(uname -s)" = "Darwin" ]; then
    if ! hash brew 2> /dev/null; then get_homebrew; fi
    install_mac $app # MacOS via Homebrew
  elif [ -f "/etc/arch-release" ] && hash pacman 2> /dev/null; then 
    install_arch $app # Arch Linux via Pacman
  elif [ -f "/etc/debian_version" ] && hash apt 2> /dev/null; then
    install_debian $app # Debian via apt-get
  else
    echo -e "${YELLOW}Skipping ${app}, as couldn't detect system type ${RESET}"
  fi
}

# Show usage instructions, help menu
print_usage
if [[ $* == *"--help"* ]]; then exit; fi

# Ask user if they'd like to proceed
if [[ ! $* == *"--auto-yes"* ]] ; then
  echo -e "${LIGHTGREEN}Are you ready ? (y/N)${RESET}"
  read -t 15 -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Proceeding was rejected by user, exiting...${RESET}"
    exit 0
  fi
fi

# For each app, check if not present and install
for app in ${core_packages[@]}; do
  if ! hash "${app}" 2> /dev/null; then
    multi_system_install $app
  else
    echo -e "${YELLOW}${app} is already installed, skipping${RESET}"
  fi
done

echo 'Admin username to add to sudoers: '
read useradmin
usermod -aG sudo $useradmin
echo "$useradmin  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# All done
echo -e "\n${LIGHTGREEN}Jobs complete, exiting${RESET}"
exit 0
