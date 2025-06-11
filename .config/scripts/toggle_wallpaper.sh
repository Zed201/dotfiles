#!/bin/bash
# toogle wallpaper and notifications off for presentation

SCRIPT_NAME="$HOME/.config/scripts/wall_script.sh"
WALL_DIR="$HOME/imagens/wallpapers"
STATE_FILE="$HOME/.cache/wallpaper_black_toggle"

mkdir -p "$(dirname "$STATE_FILE")"

if [ -f "$STATE_FILE" ]; then
        echo "🛑 Parando script de wallpaper looping..."
        pkill -f "$SCRIPT_NAME" 2>/dev/null
        pkill -f swww 2>/dev/null
        rm -f "$STATE_FILE"
        echo "✅ Modo black/desativado."
else
        echo "🚀 Iniciando swww-daemon + script de wallpapers..."
        nohup bash -c "swww-daemon & sleep 0.5 && \"$SCRIPT_NAME\" \"$WALL_DIR\"" >/dev/null 2>&1 &
        echo "on" >"$STATE_FILE"
        echo "✅ Modo looping reativado."
fi
