#!/bin/bash

# Array de pastas a serem backupadas
PASTAS=("anyrun" "code-flags.conf" "hypr" "nvim" "waybar"
        "wireplumber" "wofi" "clipse" "htop" "mako" "scripts" "wlogout" "yazi")

# Copiar cada pasta para a pasta de destino
for pasta in "${PASTAS[@]}"; do
        cp -r "$HOME/.config/$pasta" ".config/"
done
