# ECMWF Libraries Development Container
FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Create vscode user
RUN groupadd --gid 1000 vscode \
    && useradd --uid 1000 --gid vscode --shell /bin/bash --create-home vscode

# Install system dependencies
RUN apt-get update && apt-get install -y \
    # Essential build tools
    build-essential \
    gcc \
    g++ \
    gfortran \
    make \
    cmake \
    pkg-config \
    git \
    wget \
    curl \
    unzip \
    software-properties-common \
    # Libraries needed for ECMWF tools
    libnetcdf-dev \
    libhdf5-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libfontconfig1-dev \
    libxml2-dev \
    libproj-dev \
    libgeos-dev \
    # Additional utilities
    vim \
    nano \
    htop \
    tree \
    && rm -rf /var/lib/apt/lists/*

# Install Python 3.12 and 3.13
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y \
    python3.12 \
    python3.12-dev \
    python3.12-venv \
    python3.13 \
    python3.13-dev \
    python3.13-venv \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Set Python 3.12 as default
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1 \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3.12 1

# Install pip for Python 3.12
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.12

# Set working directory
WORKDIR /tmp/build

# Build and install ecCodes 2.44.0
RUN wget https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.44.0-Source.tar.gz && \
    tar -xzf eccodes-2.44.0-Source.tar.gz && \
    cd eccodes-2.44.0-Source && \
    mkdir build && cd build && \
    cmake .. \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        -DCMAKE_BUILD_TYPE=Release \
        -DENABLE_PNG=ON \
        -DENABLE_JPG=ON \
        -DENABLE_NETCDF=ON \
        -DBUILD_SHARED_LIBS=ON && \
    make -j$(nproc) && \
    make install && \
    cd /tmp/build && rm -rf eccodes-*

# Build and install Magics 4.16.0
RUN wget https://confluence.ecmwf.int/download/attachments/3473464/Magics-4.16.0-Source.tar.gz && \
    tar -xzf Magics-4.16.0-Source.tar.gz && \
    cd Magics-4.16.0-Source && \
    mkdir build && cd build && \
    cmake .. \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        -DCMAKE_BUILD_TYPE=Release \
        -DENABLE_NETCDF=ON \
        -DENABLE_GRIB=ON \
        -DENABLE_PNG=ON \
        -DENABLE_SVG=ON \
        -DENABLE_CAIRO=ON \
        -DBUILD_SHARED_LIBS=ON && \
    make -j$(nproc) && \
    make install && \
    cd /tmp/build && rm -rf Magics-*

# Clean up build directory
RUN rm -rf /tmp/build

# Update library cache
RUN ldconfig

# Set environment variables
ENV ECCODES_DIR=/usr/local
ENV MAGICS_HOME=/usr/local
ENV PATH="/usr/local/bin:$PATH"
ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

# Switch to vscode user
USER vscode
WORKDIR /home/vscode

# Install Python development packages
RUN python3 -m pip install --user --upgrade \
    pip \
    setuptools \
    wheel \
    pytest \
    pytest-cov \
    black \
    isort \
    pylint \
    mypy \
    tox \
    twine \
    build \
    findlibs \
    numpy \
    cffi

# Set up bash environment
RUN echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && \
    echo 'export PYTHONPATH="/workspaces/ecmwflibs:$PYTHONPATH"' >> ~/.bashrc && \
    echo 'alias ll="ls -la"' >> ~/.bashrc && \
    echo 'alias pytest-cov="pytest --cov=ecmwflibs --cov-report=html"' >> ~/.bashrc

WORKDIR /workspaces/ecmwflibs