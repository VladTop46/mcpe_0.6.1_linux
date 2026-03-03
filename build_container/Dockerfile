FROM fedora:39

# System update
RUN dnf -y update && dnf clean all

# --- Base SDL + OpenGL + build dependencies ---
RUN dnf -y install \
    SDL-devel \
    libpng12-devel \
    mesa-libGLES-devel \
    mesa-libEGL-devel \
    libX11-devel \
    gcc-c++ \
    cmake \
    mesa-libGL-devel \
    mesa-libGL \
    mesa-dri-drivers \
    wayland-devel \
    wayland-protocols-devel \
    libwayland-client \
    libwayland-egl \
    libwayland-cursor \
    libX11 \
    xorg-x11-xauth \
    git \
    make \
    which \
    file \
    && dnf clean all

# --- Build gl4es from source ---
RUN git clone https://github.com/ptitSeb/gl4es /tmp/gl4es && \
    cd /tmp/gl4es && \
    mkdir build && cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    make -j$(nproc) && \
    make install && \
    ldconfig && \
    rm -rf /tmp/gl4es

# --- Display environment defaults (overridable at runtime) ---
ENV DISPLAY=:0
ENV WAYLAND_DISPLAY=wayland-0
ENV XDG_RUNTIME_DIR=/tmp/xdg-runtime
ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

WORKDIR /app

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]