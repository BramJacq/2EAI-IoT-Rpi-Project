FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install cross-compiler and tools
RUN apt-get update && apt-get install -y \
    gcc-arm-linux-gnueabihf \
    g++-arm-linux-gnueabihf \
    make \
    cmake \
    git \
    build-essential \
    wget \
    vim \
    gdb \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Build pigpio for ARM using cross-compiler
RUN git clone https://github.com/joan2937/pigpio.git /tmp/pigpio && \
    cd /tmp/pigpio && \
    make CC=arm-linux-gnueabihf-gcc && \
    make install CC=arm-linux-gnueabihf-gcc && \
    rm -rf /tmp/pigpio

WORKDIR /work

# Build command (your repo provides main.c or sources)
CMD ["bash", "-c", "arm-linux-gnueabihf-gcc -o main main.c -lpigpio -lpthread && echo 'ARM binary built: /work/main'"]
