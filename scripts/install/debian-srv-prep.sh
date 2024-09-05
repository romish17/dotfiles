#!/bin/bash

# SSH Variables

SSH_CONFIG="/etc/ssh/sshd_config"
SSH_PORT=22  # Modifiez le port par défaut ici
USERNAME=""  # Remplacez par le nom d'utilisateur non-root
PUBLIC_KEY="ssh-rsa AAAA..."  # Remplacez par votre clé publique
TRUSTED_PUBLIC_IP="X.X.X.X"

# Chemin du fichier de configuration de Suricata
SURICATA_CONF="/etc/suricata/suricata.yaml"
# Interface réseau à utiliser
INTERFACE="eth0"  # Remplace "eth0" par ton interface réseau réelle
# Déclaration des fichiers de règles
RULES_DIR="/etc/suricata/rules"
RULE_HTTP_FILE="$RULES_DIR/http.rules"
RULE_HTTPS_FILE="$RULES_DIR/https.rules"
RULE_SSH_FILE="$RULES_DIR/ssh.rules"

# Chemin vers le fichier de configuration de rkhunter
RKHUNTER_CONF="/etc/rkhunter.conf"
RKHUNTER_DEFAULT="/etc/default/rkhunter"

# Wazuh 
WAZUH_MANAGER_IP="IP_DU_MANAGER_WAZUH"
AGENT_NAME="NOM_DE_L_AGENT"

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
   'lsb-release'

   # Sécurité
   'gnupg'                  # Chiffrement PGP, signature et vérification.
   'git-crypt'              # Cryptage transparent pour les dépôts git.
   'lynis'                  # Analyse du système pour détecter des problèmes de sécurité.
   'openssl'                # Toolkit de cryptographie et SSL/TLS.
   'rkhunter'               # Détection de rootkits et d'autres menaces.
   'fail2ban'               # 
   'ssh-audit'
   'ufw'
   'suricata'

   # Monitoring, gestion et statistiques
   'btop'                   # Surveillance des ressources système.
   'bmon'                   # Moniteur d'utilisation de bande passante.
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
# Vérification si l'utilisateur existe

# Vérification de la présence de sudo
if ! command -v sudo &>/dev/null; then
    echo "sudo n'est pas installé. Installation en cours..."
    apt update -qq && apt install -yqq sudo > /dev/null 2>&1
    echo "sudo a été installé."
else
    echo "sudo est déjà installé."
fi

if id "$USERNAME" &>/dev/null; then
    echo "L'utilisateur $USERNAME existe déjà."
else
    echo "L'utilisateur $USERNAME n'existe pas. Création en cours..."
    
    # Demande de mot de passe pour l'utilisateur
    sudo adduser $USERNAME
    echo "L'utilisateur $USERNAME a été créé."
fi

# Vérification si l'utilisateur est dans le groupe sudo
if groups $USERNAME | grep &>/dev/null "\bsudo\b"; then
    echo "L'utilisateur $USERNAME est déjà dans le groupe sudo."
else
    echo "Ajout de $USERNAME au groupe sudo..."
    sudo usermod -aG sudo $USERNAME
    echo "$USERNAME a été ajouté au groupe sudo."
fi

# Configuration de sudo pour ne pas demander le mot de passe
SUDOERS_FILE="/etc/sudoers.d/$USERNAME"
if [ ! -f "$SUDOERS_FILE" ]; then
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | sudo tee $SUDOERS_FILE > /dev/null
    echo "Configuration de sudo mise à jour pour $USERNAME (pas de mot de passe requis)."
else
    echo "La configuration sudo pour $USERNAME existe déjà."
fi
# Docker repos
# Ajouter la clé GPG pour Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
# Ajouter le dépôt Docker à la liste des sources apt
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Wazuh repos
echo "Ajout du dépôt Wazuh..."
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | sudo apt-key add -
echo "deb https://packages.wazuh.com/4.x/apt/ stable main" | sudo tee /etc/apt/sources.list.d/wazuh.list

echo "Mise à jour des paquets"
apt update -qq > /dev/null 2>&1
apt upgrade -yqq > /dev/null 2>&1

# Install path
mkdir -p /srv/$SRV_PATH

# Install apps
for app in ${debian_apps[@]}; do
    if dpkg -l $app &>/dev/null; then
      echo -e "${YELLOW}[Skipping]${LIGHT} ${app} is already installed${RESET}"
    elif hash flatpak 2> /dev/null && [[ ! -z $(echo $(flatpak list --columns=ref | grep $app)) ]]; then
      echo -e "${YELLOW}[Skipping]${LIGHT} ${app} is already installed via Flatpak${RESET}"
    else
      echo -e "${LIGHTGREEN}[Installing]${LIGHT} Downloading ${app}...${RESET}"
      sudo apt install ${app} --assume-yes -qq > /dev/null 2>&1
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

# Config du parefeu
echo "Configuration du parefeu..."
ufw reset
ufw default deny incoming
ufw default allow outgoing
ufw allow $SSH_PORT/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw enable
ufw reload
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

##########################################
# Suricata
##########################################

# Vérification et configuration de l'interface réseau dans suricata.yaml
if grep -q "interface: " "$SURICATA_CONF"; then
    echo "Interface trouvée dans $SURICATA_CONF. Configuration en cours..."
    sudo sed -i "s/interface: .*/interface: $INTERFACE/" "$SURICATA_CONF"
else
    echo "Ajout de l'interface $INTERFACE dans $SURICATA_CONF."
    sudo sed -i "/af-packet:/a\  - interface: $INTERFACE" "$SURICATA_CONF"
fi

# Vérifie si la section rule-files existe déjà
if grep -q "rule-files:" "$SURICATA_CONF"; then
    echo "Section 'rule-files' trouvée dans $SURICATA_CONF."
else
    echo "Ajout de la section 'rule-files' dans $SURICATA_CONF."
    echo -e "\nrule-files:" | sudo tee -a "$SURICATA_CONF"
fi

# Ajouter la règle HTTP si elle n'existe pas déjà
if grep -q "$RULE_HTTP_FILE" "$SURICATA_CONF"; then
    echo "La règle HTTP existe déjà dans $SURICATA_CONF."
else
    echo "Ajout de la règle HTTP dans $SURICATA_CONF."
    sudo sed -i "/rule-files:/a\ - $RULE_HTTP_FILE" "$SURICATA_CONF"
fi

# Ajouter la règle HTTPS si elle n'existe pas déjà
if grep -q "$RULE_HTTPS_FILE" "$SURICATA_CONF"; then
    echo "La règle HTTPS existe déjà dans $SURICATA_CONF."
else
    echo "Ajout de la règle HTTPS dans $SURICATA_CONF."
    sudo sed -i "/rule-files:/a\ - $RULE_HTTPS_FILE" "$SURICATA_CONF"
fi

# Ajouter la règle SSH si elle n'existe pas déjà
if grep -q "$RULE_SSH_FILE" "$SURICATA_CONF"; then
    echo "La règle SSH existe déjà dans $SURICATA_CONF."
else
    echo "Ajout de la règle SSH dans $SURICATA_CONF."
    sudo sed -i "/rule-files:/a\ - $RULE_SSH_FILE" "$SURICATA_CONF"
fi

# Création des fichiers de règles avec des exemples de règles si nécessaire
mkdir -p "$RULES_DIR"

if [ ! -f "$RULE_HTTP_FILE" ]; then
    echo "Création de $RULE_HTTP_FILE avec des règles par défaut."
    sudo bash -c "cat > $RULE_HTTP_FILE <<EOL
# Règles pour HTTP
alert http any any -> any any (msg:\"HTTP traffic detected\"; sid:1000002; rev:1;)
EOL"
fi

if [ ! -f "$RULE_HTTPS_FILE" ]; then
    echo "Création de $RULE_HTTPS_FILE avec des règles par défaut."
    sudo bash -c "cat > $RULE_HTTPS_FILE <<EOL
# Règles pour HTTPS
alert tls any any -> any 443 (msg:\"HTTPS traffic detected\"; sid:1000003; rev:1;)
EOL"
fi

if [ ! -f "$RULE_SSH_FILE" ]; then
    echo "Création de $RULE_SSH_FILE avec des règles par défaut."
    sudo bash -c "cat > $RULE_SSH_FILE <<EOL
# Règles pour SSH
alert tcp any any -> any 22 (msg:\"SSH traffic detected\"; sid:1000001; rev:1;)
EOL"
fi

# Redémarrage de Suricata pour appliquer les nouvelles règles
echo "Redémarrage de Suricata pour appliquer les nouvelles règles..."
sudo systemctl restart suricata

# ====================================================
# Wazuh
# ====================================================

# Installation de l'agent Wazuh
echo "Installation de l'agent Wazuh..."
sudo apt-get install -y wazuh-agent

# Configuration de l'agent
echo "Configuration de l'agent Wazuh..."
sudo sed -i "s/MANAGER_IP/$WAZUH_MANAGER_IP/" /var/ossec/etc/ossec.conf
sudo sed -i "s/AGENT_NAME/$AGENT_NAME/" /var/ossec/etc/ossec.conf

# Enregistrement de l'agent
echo "Enregistrement de l'agent..."
sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent

# Confirmation de l'installation
echo "Vérification de l'installation..."
sudo systemctl status wazuh-agent

# ====================================================
# Rkhunter
# ====================================================

sed -i 's/#\?MAIL-ON-WARNING=.*/#MAIL-ON-WARNING=root@localhost/' $RKHUNTER_CONF
sed -i 's/#\?MAIL_CMD=.*"/MAIL_CMD=mail -s "[rkhunter] Warnings found for \${HOST_NAME}"/' $RKHUNTER_CONF

sed -i 's/#\?WEB_CMD=.*/WEB_CMD=wget/' $RKHUNTER_CONF
sed -i 's/DB_UPDATE_EMAIL=".*"/DB_UPDATE_EMAIL="true"/' $RKHUNTER_CONF
sed -i 's/#\?UPDATE_MIRRORS=.*/UPDATE_MIRRORS=1/' $RKHUNTER_CONF
sed -i 's/#\?MIRRORS_MODE=.*/MIRRORS_MODE=0/' $RKHUNTER_CONF

echo 'ALLOWPROCDELFILE=/usr/sbin/cron' >> $RKHUNTER_CONF
echo 'ALLOWPROCDELFILE=/usr/bin/dash' >> $RKHUNTER_CONF
echo 'ALLOWPROCDELFILE=/usr/bin/run-parts' >> $RKHUNTER_CONF
echo 'SCRIPTWHITELIST=/usr/bin/egrep' >> $RKHUNTER_CONF
echo 'SCRIPTWHITELIST=/usr/bin/fgrep' >> $RKHUNTER_CONF
echo 'SCRIPTWHITELIST=/usr/bin/which' >> $RKHUNTER_CONF
echo 'PORT_PATH_WHITELIST=/usr/sbin/portsentry' >> $RKHUNTER_CONF
echo 'ALLOW_SSH_ROOT_USER=prohibit-password' >> $RKHUNTER_CONF

sed -i 's~#\?ALLOWPROCLISTEN=/sbin/dhclient~ALLOWPROCLISTEN=/sbin/dhclient~' $RKHUNTER_CONF
sed -i 's/^DISABLE_TESTS/#&/' $RKHUNTER_CONF
sed -i 's/^#\?PKGMGR=.*/PKGMGR=DPKG/' $RKHUNTER_CONF
sed -i 's/^#\?\(ALLOW_SSH_PROT_V1\)=.*/\1=0/' $RKHUNTER_CONF

sudo bash -c "cat > $RKHUNTER_DEFAULT << EOF
#Perform security check daily
CRON_DAILY_RUN="true"
#Enable weekly database updates.
CRON_DB_UPDATE="true"
#Enable automatic database updates
APT_AUTOGEN="true"
EOF"

sudo chmod +x $RKHUNTER_DEFAULT

# 
rkhunter --update
rkhunter --propupd
rkhunter -c --enable all --disable none --skip-keypress
#rkhunter --checkall
