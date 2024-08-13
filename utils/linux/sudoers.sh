#!/bin/bash
echo 'Username : '
read useradmin
apt update && apt upgrade -yy
apt install sudo -yy
usermod -aG sudo $useradmin
echo "$useradmin  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$useradmin