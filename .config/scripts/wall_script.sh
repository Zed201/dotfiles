#!/bin/sh
# esta com um chattr +i para não ser excluido acidentalmente
# Changes the wallpaper to a randomly chosen image in a given directory
# at a set interval.

DEFAULT_INTERVAL=60 # In seconds

# Função para calcular luminância (0-1)
calculate_luminance() {
  local hex=${1:1}
  local r=$(printf "%d" 0x${hex:0:2})
  local g=$(printf "%d" 0x${hex:2:2})
  local b=$(printf "%d" 0x${hex:4:2})
  echo "scale=4; 0.2126*$r/255 + 0.7152*$g/255 + 0.0722*$b/255" | bc
}

if [ $# -lt 1 ] || [ ! -d "$1" ]; then
  printf "Usage:\n\t\e[1m%s\e[0m \e[4mDIRECTORY\e[0m [\e[4mINTERVAL\e[0m]\n" "$0"
  printf "\tChanges the wallpaper to a randomly chosen image in DIRECTORY every\n\tINTERVAL seconds (or every %d seconds if unspecified)." "$DEFAULT_INTERVAL"
  exit 1
fi

# See swww-img(1)
RESIZE_TYPE="crop"
export SWWW_TRANSITION_FPS="${SWWW_TRANSITION_FPS:-60}"
export SWWW_TRANSITION_STEP="${SWWW_TRANSITION_STEP:-2}"

while true; do
  find "$1" -type f |
    while read -r img; do
      # randomize the imgs
      echo "$(</dev/urandom tr -dc a-zA-Z0-9 | head -c 8):$img"
    done |
      sort -n | cut -d':' -f2- |
      while read -r img; do
        swww img --resize="$RESIZE_TYPE" "$img"
        # change the colors of waybar
        # Extrai as 2 cores principais
        read _back _text <<<$(magick "$img" -resize 200x200 -kmeans 2 -unique-colors -blur 0x1 txt:- | tail -n +2 | awk '{print substr($3, 1, 7)}' | tr '\n' ' ')

        # Determina cor do texto baseado no contraste
        luminance=$(calculate_luminance "$_back")
        if (($(echo "$luminance > 0.5" | bc -l))); then
          # Fundo claro -> texto escuro
          _text="#000000"
        else
          # Fundo escuro -> texto claro
          _text="#FFFFFF"
        fi

        # Aplica ao template
        sed "s/#303446/$_back/g; s/#ffffff/$_text/g" \
          ~/.config/waybar/style_template.css >~/.config/waybar/style.css


        sleep "${2:-$DEFAULT_INTERVAL}"
  done
done
