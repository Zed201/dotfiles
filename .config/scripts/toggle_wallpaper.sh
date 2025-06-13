#!/bin/bash
# Script de toggle para wallpaper aleatório (wall_script) e notificações mako
# Agora com opção de wallpaper preto ao invés de pausar

WALL_SCRIPT_NAME="wall_script"
BLACK_WALLPAPER="/tmp/black_wallpaper.png"

# Cria um wallpaper preto se não existir
create_black_wallpaper() {
        if [ ! -f "$BLACK_WALLPAPER" ]; then
                magick convert -size 1920x1080 xc:black "$BLACK_WALLPAPER"
        fi
}

# Função para encontrar o PID principal do wall_script
find_wallpaper_pid() {
        # Lista todos os processos que contêm o nome do script
        pids=$(pgrep -f "$WALL_SCRIPT_NAME")

        # Filtra para pegar apenas o processo principal
        for pid in $pids; do
                ppid=$(ps -o ppid= -p $pid | tr -d ' ')
                if ! echo "$pids" | grep -q "^$ppid$"; then
                        echo $pid
                        return
                fi
        done

        echo "$pids" | head -n1
}

# Função para alternar entre wallpaper normal e preto
toggle_wallpaper() {
        local wp_pid=$(find_wallpaper_pid)
        local state_file="$HOME/.cache/wallpaper_state"

        if [ -n "$wp_pid" ]; then
                create_black_wallpaper

                # Cria arquivo de estado se não existir
                if [ ! -f "$state_file" ]; then
                        echo "normal" >"$state_file"
                fi

                local current_state
                current_state=$(<"$state_file")

                if [[ "$current_state" == "black" ]]; then
                        kill -USR2 "$wp_pid"
                        echo "Wallpaper normal retomado (PID $wp_pid)"
                        echo "normal" >"$state_file"
                else
                        swww img --resize=crop "$BLACK_WALLPAPER"
                        echo "Wallpaper definido como preto (PID $wp_pid)"
                        echo "black" >"$state_file"
                fi
        else
                echo "Processo do wallpaper não encontrado"
        fi
}

# Função principal de toggle
toggle_services() {
        toggle_wallpaper

        # Verifica os modos ativos

        # Verifica se o modo "do-not-disturb" está entre os ativos
        if makoctl mode | grep -q "^do-not-disturb"; then
                makoctl mode -r do-not-disturb
                notify-send "🔔 Modo Não Perturbe desativado"
        else

                notify-send "🔕 Modo Não Perturbe ativado"
                makoctl mode -a do-not-disturb

        fi

}

# lembrar de usar os comandos do mako para sincar
toggle_services
