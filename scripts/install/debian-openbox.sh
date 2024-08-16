#!/usr/bin/env bash

################################################################
# 📜 Openbox Install Script                                    #
################################################################

# Download assets
wget https://github.com/romish17/install/raw/main/custom/themes/Nordic-master.zip
wget https://github.com/romish17/install/raw/main/custom/icons/Nordzy.tar.gz
wget https://github.com/romish17/install/raw/main/custom/icons/Nordzy-dark.tar.gz

unzip Nordic-master.zip -d /tmp/

tar -xzvf Nordzy.tar.gz -C /tmp/
tar -xzvf Nordzy-dark.tar.gz -C /tmp/



sudo mv -r /tmp/Nordic-master/gtk-3.0 /usr/share/themes/Nordic
sudo mv -r /tmp/Nordzy-icon-main/gtk-3.0 /usr/share/icons/Nordzy
sudo mv -r /tmp/Nordzy-icon-main/gtk-3.0 /usr/share/icons/Nordzy-dark