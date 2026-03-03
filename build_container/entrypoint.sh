#!/bin/bash
set -e

# XDG runtime dir
mkdir -p "${XDG_RUNTIME_DIR:-/tmp/xdg-runtime}"
chmod 0700 "${XDG_RUNTIME_DIR:-/tmp/xdg-runtime}"

# --- Автодетект дисплея ---
if [ -n "$WAYLAND_DISPLAY" ] && [ -S "${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY}" ]; then
    echo "[entrypoint] Wayland detected: $WAYLAND_DISPLAY"
    export QT_QPA_PLATFORM=wayland
    export SDL_VIDEODRIVER=wayland
    export GDK_BACKEND=wayland
elif [ -n "$DISPLAY" ]; then
    echo "[entrypoint] X11 detected: $DISPLAY"
    export QT_QPA_PLATFORM=xcb
    export SDL_VIDEODRIVER=x11
    export GDK_BACKEND=x11
else
    echo "[entrypoint] WARNING: No display detected. Set DISPLAY or WAYLAND_DISPLAY."
fi

# --- Переходим в рабочую директорию проекта ---
PROJECT_DIR="/handheld/project/linux"

if [ -d "$PROJECT_DIR" ]; then
    echo "[entrypoint] cd -> $PROJECT_DIR"
    cd "$PROJECT_DIR"
else
    echo "[entrypoint] WARNING: $PROJECT_DIR not found, staying in /handheld"
    cd /handheld 2>/dev/null || true
fi

exec "$@"