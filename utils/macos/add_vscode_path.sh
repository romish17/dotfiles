#!/bin/bash
ZSHRC_FILE="$HOME/.zshrc"
VS_CODE_PATH='export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"'
# Vérifie si la ligne existe déjà dans .zshrc
if grep -Fxq "$VS_CODE_PATH" "$ZSHRC_FILE"
then
    echo "La ligne est déjà présente dans $ZSHRC_FILE"
else
    # Ajoute la ligne à la fin du fichier .zshrc
    echo "$VS_CODE_PATH" >> "$ZSHRC_FILE"
    echo "La ligne a été ajoutée à $ZSHRC_FILE"
fi
# Recharge le fichier .zshrc
source "$ZSHRC_FILE"
echo "Le fichier .zshrc a été rechargé."
