#!/bin/bash

# Troubleshooting script for dev container issues

echo "🔍 Dev Container Troubleshooting Information"
echo "============================================="
echo ""

echo "📋 System Information:"
echo "  OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'=' -f2 | tr -d '\"')"
echo "  User: $(whoami)"
echo "  Home: $HOME"
echo "  Working Directory: $(pwd)"
echo "  Shell: $SHELL"
echo ""

echo "🐍 Python Information:"
echo "  Python Version: $(python3 --version 2>/dev/null || echo 'Python3 not found')"
echo "  Python Path: $(which python3 2>/dev/null || echo 'Not found')"
echo "  Pip Version: $(pip --version 2>/dev/null || echo 'Pip not found')"
echo ""

echo "📦 Key Packages:"
packages=("pytest" "black" "pylint" "mypy" "numpy" "cffi")
for pkg in "${packages[@]}"; do
    if python3 -c "import $pkg" 2>/dev/null; then
        version=$(python3 -c "import $pkg; print(getattr($pkg, '__version__', 'unknown'))" 2>/dev/null || echo "unknown")
        echo "  ✅ $pkg: $version"
    else
        echo "  ❌ $pkg: not installed"
    fi
done
echo ""

echo "🔧 System Tools:"
tools=("git" "gcc" "cmake" "pkg-config")
for tool in "${tools[@]}"; do
    if command -v "$tool" >/dev/null 2>&1; then
        version=$($tool --version 2>/dev/null | head -n1 || echo "version unknown")
        echo "  ✅ $tool: $version"
    else
        echo "  ❌ $tool: not found"
    fi
done
echo ""

echo "🌍 ECMWF Libraries:"
if pkg-config --exists eccodes 2>/dev/null; then
    echo "  ✅ eccodes: $(pkg-config --modversion eccodes)"
else
    echo "  ❌ eccodes: not found via pkg-config"
fi

if python3 -c "import eccodes" 2>/dev/null; then
    echo "  ✅ eccodes Python module: available"
else
    echo "  ❌ eccodes Python module: not available"
fi
echo ""

echo "📁 Workspace Information:"
echo "  Current directory: $(pwd)"
echo "  Directory contents:"
ls -la 2>/dev/null | head -10
echo ""

echo "🔧 Suggested Actions:"
if ! command -v python3 >/dev/null 2>&1; then
    echo "  - Install Python 3"
fi
if ! python3 -c "import pytest" 2>/dev/null; then
    echo "  - Run: pip install pytest"
fi
if [ ! -f "setup.py" ] && [ ! -f "pyproject.toml" ]; then
    echo "  - Navigate to the correct project directory"
else
    echo "  - Run: pip install -e ."
    echo "  - Run: pytest (to run tests)"
fi
echo ""

echo "For more help, check .devcontainer/README.md"