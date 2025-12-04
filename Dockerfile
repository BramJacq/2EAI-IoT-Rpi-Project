# Base image for ARM cross-compilation
FROM --platform=linux/arm ubuntu:22.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update and install required packages
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    cmake \
    wget \
    vim \
    net-tools \
    gdb \
    clang \
    ca-certificates \
    python3 \
    python3-distutils \
    && rm -rf /var/lib/apt/lists/*

# --- Build pigpio from source ---
RUN git clone https://github.com/joan2937/pigpio.git /tmp/pigpio && \
    cd /tmp/pigpio && \
    make && \
    make install && \
    ldconfig && \
    rm -rf /tmp/pigpio

# --- Create working directory ---
WORKDIR /work

# The GitHub Action mounts code here with:
#   --mount type=bind,src=$GITHUB_WORKSPACE/pigpio,dst=/work/pigpio
#   (or your own project folder)
#
# So we do NOT copy files here.

# --- Compile your program automatically on container start ---
CMD ["bash", "-c", "gcc -o main main.c -lpigpio -lpthread && echo 'Build complete: /work/main'"]
