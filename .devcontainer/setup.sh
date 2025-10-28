#!/bin/bash

# Setup script for ecmwflibs development container
# This script runs when the container is created

set -e

echo "🚀 Setting up ecmwflibs development environment..."
echo "Container user: $(whoami)"
echo "Working directory: $(pwd)"
echo "Python version: $(python3 --version)"

# Update package lists
sudo apt-get update

# Install system dependencies needed for ECMWF libraries
echo "Installing system dependencies..."
sudo apt-get install -y \
    build-essential \
    cmake \
    pkg-config \
    gfortran \
    libnetcdf-dev \
    libhdf5-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libfontconfig1-dev \
    libxml2-dev \
    libproj-dev \
    libgeos-dev \
    libeccodes-dev \
    libeccodes-tools \
    wget \
    curl \
    unzip

# Install Python dependencies
echo "Installing Python dependencies..."
pip install --upgrade pip setuptools wheel

# Create development requirements
cat > /tmp/dev-requirements.txt << 'EOF'
# Development tools
pytest>=7.0.0
pytest-cov>=4.0.0
black>=22.0.0
isort>=5.10.0
pylint>=2.15.0
mypy>=1.0.0
tox>=4.0.0
twine>=4.0.0
build>=0.10.0

# Core dependencies
findlibs>=0.0.5
numpy>=1.21.0
cffi>=1.15.0

# ECMWF related packages (if available via pip)
eccodes
netcdf4
EOF

# Install development requirements
echo "📦 Installing Python development packages..."
pip install -r /tmp/dev-requirements.txt || {
    echo "❌ Failed to install some packages from dev-requirements.txt"
    echo "🔄 Trying to install packages individually..."
    pip install pytest black pylint mypy || echo "⚠️  Some packages failed to install"
}

# Try to install magics if available
echo "🌍 Attempting to install ECMWF magics..."
pip install magics || echo "⚠️  Warning: Could not install magics via pip - will need to build from source if required"

# Set up git configuration (if not already set)
if [ -z "$(git config --global user.name)" ]; then
    echo "Setting up default git configuration..."
    git config --global user.name "Dev Container User"
    git config --global user.email "dev@example.com"
    echo "Note: Please update git config with your actual name and email"
fi

# Create useful aliases and environment setup
cat >> ~/.bashrc << 'EOF'

# Useful aliases for development
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias pytest-cov='pytest --cov=ecmwflibs --cov-report=html'
alias lint='pylint ecmwflibs/'

# Environment variables for ECMWF libraries and development
export ECCODES_DIR=/usr
export MAGICS_HOME=/usr/local
export PATH="/usr/local/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"
export PYTHONPATH="/workspaces/ecmwflibs:$PYTHONPATH"
EOF

# Make the workspace directory if it doesn't exist
mkdir -p /workspaces

echo "Setup complete!"
echo ""
echo "Available commands:"
echo "  - pytest: Run tests"
echo "  - black: Format code" 
echo "  - pylint: Lint code"
echo "  - tox: Run tests across environments"
echo ""
echo "To get started:"
echo "  cd /workspaces/ecmwflibs"
echo "  pip install -e ."
echo "  pytest"