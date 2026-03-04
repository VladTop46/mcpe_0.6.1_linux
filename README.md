# Minecraft Pocket Edition v0.6.1 Docker build system

This repository does **not** contain the original game source code and will never include it.

The purpose of this project is to provide a reproducible Docker-based build environment for Minecraft Pocket Edition v0.6.1, allowing researchers and enthusiasts to study and preserve an early snapshot of the engine in a native Linux x86_64 configuration.

Minecraft began as an independent creation, and many early versions hold historical and technical significance for the community. This repository is a small preservation-oriented effort focused purely on build reproducibility and technical exploration.

If you have independently obtained access to the original source snapshot, this container allows you to build a native Linux version in a controlled and reproducible environment.

No original assets, binaries, or proprietary materials are distributed here.

## Build Instructions

> This repository does not include the original source code.
> You must independently obtain access to the original Minecraft Pocket Edition v0.6.1 source snapshot before proceeding.

### 0. Clone this repository
```
git clone https://github.com/VladTop46/mcpe_0.6.1_linux
```

### 1. Prepare the source tree

Place the original `handheld` source directory inside this repository directory, so that the structure looks like this:
```
mcpe_0.6.1_linux/
├── build_container
├── handheld
├── mcpe_linux_port.patch
└── README.md
```

### 1.1 Convert CRLF source files to LF
```
find . -type f -name "*.cpp" -o -name "*.h" | xargs dos2unix
```

You need to install dos2unix package for your distro

### 2. Apply the Linux port patch

```bash
cd handheld
patch -p1 < ../mcpe_linux_port.patch
```

### 3. Build the Docker container
```
cd ../build_container
docker build -t gl4es-app .
```

### 4. Enter the build environment
```
./run.sh
```

### 5. Compile the project (inside a container)
```
make
```

### 6. Run the game (inside a container)
```
./minecraftpe
```

The resulting binary is a native Linux x86_64 build using X11, EGL and OpenGL/GLES.

### P.S.

This early version of the game contains numerous technical limitations — some related to porting, others inherent to its alpha state and the condition of the historical source snapshot.

Nevertheless, the primary goal of this project — achieving reproducible native Linux builds — has been successfully accomplished.

It would be wonderful to see official support for historical and research-oriented use of early engine versions, reflecting the long-standing interest and dedication of the community.