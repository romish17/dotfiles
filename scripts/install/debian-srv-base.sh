#!/bin/bash

# SSH Variables

SSH_CONFIG="/etc/ssh/sshd_config"
SSH_PORT=22  # Modifiez le port par défaut ici
USERNAME=""  # Remplacez par le nom d'utilisateur non-root
PUBLIC_KEY="ssh-rsa AAAA..."  # Remplacez par votre clé publique

# Color variables
LIGHTGREEN='\033[1;32m'
YELLOW='\033[0;93m'
LIGHT='\033[2;32m'
CYAN_B='\033[1;96m'
RESET='\033[0m'

# Création des répertoires
SRV_PATH={'Docker','Backup'}

debian_apps=(

   # Base
   'apt-transport-https'
   'ca-certificates'
   'curl'
   'gnupg'
   'lsb-release'

   # Sécurité
   'gnupg'                  # Chiffrement PGP, signature et vérification.
   'git-crypt'              # Cryptage transparent pour les dépôts git.
   'lynis'                  # Analyse du système pour détecter des problèmes de sécurité.
   'openssl'                # Toolkit de cryptographie et SSL/TLS.
   'rkhunter'               # Détection de rootkits et d'autres menaces.
   'fail2ban'               # 
   'ssh-audit'

   # Monitoring, gestion et statistiques
   'btop'                   # Surveillance des ressources système.
   'bmon'                   # Moniteur d'utilisation de bande passante.
   'ctop'                   # Surveillance des conteneurs.
   'gping'                  # Outil interactif de ping avec graphique.
   'glances'                # Moniteur de ressources avec interface web et API.
   'goaccess'               # Analyseur et visualiseur de logs web.
   'speedtest-cli'          # Outil de test de vitesse de connexion en ligne de commande.

   # Docker
   'docker-ce'
   'docker-ce-cli'
   'containerd.io'
   'docker-compose-plugin'
)

# Demander le nom d'utilisateur
read -p "Entrez le nom de l'utilisateur non-root pour la connexion SSH : " USERNAME
# Vérifier si l'utilisateur existe
id "$USERNAME" &>/dev/null && echo "L'utilisateur $USERNAME existe." || { echo "Erreur : L'utilisateur $USERNAME n'existe pas. Veuillez créer cet utilisateur avant d'exécuter ce script."; exit 1; }
# Vérifier si l'utilisateur est dans le groupe sudo
groups "$USERNAME" | grep &>/dev/null '\bsudo\b' && echo "L'utilisateur $USERNAME est dans le groupe sudo." || { echo "Erreur : L'utilisateur $USERNAME n'est pas dans le groupe sudo. Ajoutez cet utilisateur au groupe sudo avant de continuer."; exit 1; }

# Docker repos
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update && apt upgrade -yy

# Install path
mkdir -p /srv/$SRV_PATH

# Install apps
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

##########################################
# Hardening SSH
##########################################

echo "Change SSH port"
sed -i "s/#Port 22/Port $SSH_PORT/" $SSH_CONFIG
echo "Disable password connection"
sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/" $SSH_CONFIG
echo "Disable access root"
sed -i "s/PermitRootLogin yes/PermitRootLogin no/" $SSH_CONFIG
echo "Enable public key auth"
sed -i "s/#PubkeyAuthentication yes/PubkeyAuthentication yes/" $SSH_CONFIG
echo "Remove small Diffie-Hellman moduli"
awk '$5 >= 3071' /etc/ssh/moduli > /etc/ssh/moduli.safe
mv /etc/ssh/moduli.safe /etc/ssh/moduli
echo "Enable the ED25519 and RSA HostKey directives in the /etc/ssh/sshd_config file:"
echo -e "\nHostKey /etc/ssh/ssh_host_ed25519_key\nHostKey /etc/ssh/ssh_host_rsa_key" >> $SSH_CONFIG
echo "Restrict supported key exchange, cipher, and MAC algorithms"
echo -e "# Restrict key exchange, cipher, and MAC algorithms, as per sshaudit.com\n# hardening guide.\nKexAlgorithms sntrup761x25519-sha512@openssh.com,gss-curve25519-sha256-,curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256,gss-group16-sha512-,diffie-hellman-group16-sha512\n\nCiphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-gcm@openssh.com,aes128-ctr\n\nMACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com\n\nHostKeyAlgorithms sk-ssh-ed25519-cert-v01@openssh.com,ssh-ed25519-cert-v01@openssh.com,rsa-sha2-512-cert-v01@openssh.com,rsa-sha2-256-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,ssh-ed25519,rsa-sha2-512,rsa-sha2-256\n\nCASignatureAlgorithms sk-ssh-ed25519@openssh.com,ssh-ed25519,rsa-sha2-512,rsa-sha2-256\n\nGSSAPIKexAlgorithms gss-curve25519-sha256-,gss-group16-sha512-\n\nHostbasedAcceptedAlgorithms sk-ssh-ed25519-cert-v01@openssh.com,ssh-ed25519-cert-v01@openssh.com,rsa-sha2-512-cert-v01@openssh.com,rsa-sha2-256-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,ssh-ed25519,rsa-sha2-512,rsa-sha2-256\n\nPubkeyAcceptedAlgorithms sk-ssh-ed25519-cert-v01@openssh.com,ssh-ed25519-cert-v01@openssh.com,rsa-sha2-512-cert-v01@openssh.com,rsa-sha2-256-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,ssh-ed25519,rsa-sha2-512,rsa-sha2-256" > /etc/ssh/sshd_config.d/ssh-audit_hardening.conf


# Ajouter une clé publique au compte utilisateur
echo "Ajout de la clé publique pour l'utilisateur $USERNAME..."
mkdir -p /home/$USERNAME/.ssh
echo $PUBLIC_KEY > /home/$USERNAME/.ssh/authorized_keys
chmod 700 /home/$USERNAME/.ssh
chmod 600 /home/$USERNAME/.ssh/authorized_keys
chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh

# 11. Redémarrer le service SSH pour appliquer les changements
echo "Redémarrage du service SSH..."
systemctl restart ssh

##########################################
# Docker conf
##########################################

sudo usermod -aG docker $USER
sudo systemctl enable docker
sudo systemctl start docker

##########################################
# Configuration du parefeu
##########################################

command -v ufw &> /dev/null && echo "UFW est déjà installé." || { echo "UFW n'est pas installé. Installation de UFW..."; apt-get update && apt-get install ufw -y; }
# Config du parefeu
echo "Réinitialisation des règles UFW par défaut..."
ufw reset
ufw allow $SSH_PORT/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw enable
ufw status verbose
echo "Configuration UFW terminée."

##########################################
# Conf fail2ban
##########################################
sudo bash -c 'cat > /etc/fail2ban/jail.local <<EOL
[sshd]
enabled = true
port = ssh
logpath = %(sshd_log)s
maxretry = 5
bantime = 3600
EOL'

sudo systemctl enable fail2ban
sudo systemctl start fail2ban
