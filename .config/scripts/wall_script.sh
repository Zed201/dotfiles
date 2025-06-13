#!/bin/bash
# Script para randomizar wallpapers com instância única e controle por sinal
# nohup bash -c "$HOME/.config/scripts/wall_script.sh $HOME/imagens/wallpapers" > /dev/null 2>&1 &

# Configurações
DEFAULT_INTERVAL=30
LOCK_FILE="/tmp/wall_script.lock"
STATE_FILE="/tmp/wall_script.state"
STATE="ativo"

# Garante instância única
if [ -f "$LOCK_FILE" ]; then
        if ps -p "$(cat "$LOCK_FILE")" >/dev/null 2>&1; then
                echo "Script já em execução (PID $(cat "$LOCK_FILE"))" >&2
                exit 1
        else
                rm "$LOCK_FILE"
        fi
fi

echo $$ >"$LOCK_FILE"
trap 'rm -f "$LOCK_FILE" "$STATE_FILE"' EXIT

# Handlers de sinal
handle_usr1() {
        echo "pausado" >"$STATE_FILE"
        echo "[USR1] Wallpaper pausado"
}
handle_usr2() {
        echo "ativo" >"$STATE_FILE"
        echo "[USR2] Wallpaper retomado"
}
trap 'handle_usr1' USR1
trap 'handle_usr2' USR2

# Inicializa estado
echo "$STATE" >"$STATE_FILE"

# Função para calcular luminância
calculate_luminance() {
        local hex=${1:1}
        local r=$(printf "%d" 0x${hex:0:2})
        local g=$(printf "%d" 0x${hex:2:2})
        local b=$(printf "%d" 0x${hex:4:2})
        echo "scale=4; 0.2126*$r/255 + 0.7152*$g/255 + 0.0722*$b/255" | bc
}

# Verificação de argumentos
if [ $# -lt 1 ] || [ ! -d "$1" ]; then
        echo "Uso: $0 <diretório> [intervalo]" >&2
        exit 1
fi

# Configurações do swww
RESIZE_TYPE="crop"
export SWWW_TRANSITION_FPS="${SWWW_TRANSITION_FPS:-60}"
export SWWW_TRANSITION_STEP="${SWWW_TRANSITION_STEP:-2}"

# Loop principal
while true; do
        # Coleta e embaralha imagens
        mapfile -d '' -t images < <(find "$1" -type f -print0)
        images=($(printf "%s\n" "${images[@]}" | shuf))

        for img in "${images[@]}"; do
                STATE=$(cat "$STATE_FILE")

                if [[ "$STATE" == "ativo" ]]; then
                        swww img --resize="$RESIZE_TYPE" "$img"

                        # Extrai cores para a Waybar
                        colors=$(magick "$img" -resize 200x200 -kmeans 2 -unique-colors -blur 0x1 txt:- | tail -n +2 | awk '{print substr($3, 1, 7)}' | tr '\n' ' ')
                        read _back _text <<<"$colors"

                        luminance=$(calculate_luminance "$_back")
                        if (($(echo "$luminance > 0.5" | bc -l))); then
                                _text="#000000"
                        else
                                _text="#FFFFFF"
                        fi

                        sed "s/#303446/$_back/g; s/#ffffff/$_text/g" \
                                ~/.config/waybar/style_template.css >~/.config/waybar/style.css
                fi

                sleep "${2:-$DEFAULT_INTERVAL}"
        done
done
