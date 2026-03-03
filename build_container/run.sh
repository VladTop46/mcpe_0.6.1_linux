#!/bin/bash
# =====================================================
# run.sh — запуск контейнера с пробросом окна в хост
# =====================================================
IMAGE="gl4es-app"
APP="${1:-/bin/bash}"

# Путь к ../handheld относительно расположения этого скрипта
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HANDHELD_DIR="$(realpath "${SCRIPT_DIR}/../handheld")"

if [ ! -d "$HANDHELD_DIR" ]; then
    echo "[run] ERROR: Directory not found: $HANDHELD_DIR"
    echo "[run] Expected structure: ../handheld relative to run.sh"
    exit 1
fi

echo "[run] Mounting handheld: $HANDHELD_DIR -> /handheld"

RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

if [ -n "$WAYLAND_DISPLAY" ] && [ -S "${RUNTIME_DIR}/${WAYLAND_DISPLAY}" ]; then
    echo "[run] Mode: Wayland ($WAYLAND_DISPLAY)"
    docker run -it --rm \
        --name gl4es-container \
        -e WAYLAND_DISPLAY="$WAYLAND_DISPLAY" \
        -e XDG_RUNTIME_DIR=/tmp/xdg-runtime \
        -v "${RUNTIME_DIR}/${WAYLAND_DISPLAY}:/tmp/xdg-runtime/${WAYLAND_DISPLAY}" \
        --device /dev/dri \
        -v /dev/dri:/dev/dri \
        -v "${HANDHELD_DIR}:/handheld" \
        "$IMAGE" "$APP"

elif [ -n "$DISPLAY" ]; then
    echo "[run] Mode: X11 ($DISPLAY)"
    xhost +local:docker 2>/dev/null || true
    docker run -it --rm \
        --name gl4es-container \
        -e DISPLAY="$DISPLAY" \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v "$HOME/.Xauthority:/root/.Xauthority:ro" \
        --device /dev/dri \
        -v /dev/dri:/dev/dri \
        -v "${HANDHELD_DIR}:/handheld" \
        "$IMAGE" "$APP"
else
    echo "[run] ERROR: No DISPLAY or WAYLAND_DISPLAY found."
    exit 1
fi