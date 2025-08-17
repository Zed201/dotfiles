#!/bin/bash

# Array de pastas a serem backupadas
PASTAS=("code-flags.conf" "hypr" "nvim" "waybar"
        "wireplumber" "clipse" "htop" "scripts" "wlogout" "yazi" "fuzzel" "sherlock" "ghostty" "vicinae")

# Copiar cada pasta para a pasta de destino
for pasta in "${PASTAS[@]}"; do
        cp -r "$HOME/.config/$pasta" ".config/"
done
