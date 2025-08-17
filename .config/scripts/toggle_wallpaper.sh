#!/bin/bash
# toggle_wallpaper.sh - Para/Reinicia wallpapers no Hyprland

WALL_SCRIPT="$HOME/.config/scripts/wall_script.sh" # Seu script de wallpapers em loop
STATE_FILE="$HOME/.cache/wallpaper_state"
BLACK_WALL="$HOME/.cache/black_wall.png"
WALL_DIR="$HOME/imagens/wallpapers/"

# Cria um wallpaper preto se não existir
[ ! -f "$BLACK_WALL" ] && convert -size 1920x1080 xc:black "$BLACK_WALL"

# Verifica se o wallpaper está ativo (STATE_FILE existe)
if [ -f "$STATE_FILE" ]; then
        echo "🛑 Parando wallpapers e ativando modo preto..."

        # Mata TODOS os processos relacionados (incluindo o loop do script)
        pkill -f "$WALL_SCRIPT" 2>/dev/null
        pkill -x mpvpaper 2>/dev/null
        # pkill -x swww 2>/dev/null
        pkill -x swaybg 2>/dev/null
        killall mpvpaper swww 2>/dev/null # Garantia extra

        # Força um wallpaper preto (Hyprland compatível)
        # swww img "$BLACK_WALL" --transition-type none && echo "✅ Tela preta (swww)"
        swaybg -i "$BLACK_WALL" &

        rm -f "$STATE_FILE"
else
        echo "🚀 Iniciando wallpapers..."

        # Garante que não há processos antigos rodando
        pkill -f "$WALL_SCRIPT" 2>/dev/null
        pkill -x mpvpaper 2>/dev/null
        # pkill -x swww 2>/dev/null
        pkill -x swaybg 2>/dev/null

        # Inicia o wallpaper em loop (não usa nohup para evitar reinício indesejado)
        bash "$WALL_SCRIPT" "$WALL_DIR" &
        disown

        echo "on" >"$STATE_FILE"
        echo "✅ Wallpaper em loop reiniciado."
fi
