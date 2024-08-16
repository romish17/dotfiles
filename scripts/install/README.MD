# Debian custom script

Ce dépôt contient un script d'installation automatisée pour Debian, permettant d'installer une liste de paquets essentiels et utiles. Le script configure également certains outils de base pour votre système.

## Prérequis

Avant d'exécuter le script, assurez-vous que vous avez les prérequis suivants :

- **Système Debian** : Le script est conçu pour Debian et ses dérivés comme Ubuntu.
- **Accès root** : Vous devrez avoir des privilèges root pour installer des paquets. Utilisez `sudo` pour exécuter le script en tant qu'administrateur.

## Installation du Script

Pour installer les paquets définis dans le script, exécutez la commande suivante dans votre terminal :

```bash
bash <(wget -qO- https://raw.githubusercontent.com/romish17/install/main/scripts/install/debian-apt.sh)