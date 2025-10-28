#!/bin/bash

# Post-create script for ecmwflibs development container
# This script runs after the container is created

set -e

echo "Setting up ecmwflibs development environment..."

# Ensure we're in the workspace directory
cd /workspace

# Create development requirements file
cat > dev-requirements.txt << 'EOF'
# Development tools
pytest>=7.0.0
pytest-cov>=4.0.0
black>=22.0.0
isort>=5.10.0
pylint>=2.15.0
mypy>=0.990
tox>=4.0.0
twine>=4.0.0
build>=0.10.0

# Runtime dependencies
findlibs>=0.0.5
numpy>=1.21.0
cffi>=1.15.0

# Testing dependencies from tests/requirements.txt
magics
eccodes
pytest
EOF

# Install development requirements in virtual environments
echo "Installing development requirements for Python 3.12..."
source /home/vscode/venv-py312/bin/activate
pip install -r dev-requirements.txt
deactivate

echo "Installing development requirements for Python 3.13..."
source /home/vscode/venv-py313/bin/activate
pip install -r dev-requirements.txt
deactivate

# Create a simple tox configuration for testing multiple Python versions
cat > tox-dev.ini << 'EOF'
[tox]
envlist = py312,py313
isolated_build = true
skip_missing_interpreters = true

[testenv]
deps = 
    pytest
    pytest-cov
    magics
    eccodes
    numpy
    findlibs
commands = 
    python -m pytest tests/ -v

[testenv:py312]
basepython = python3.12

[testenv:py313]
basepython = python3.13
EOF

# Create a development script for easy testing
cat > test-all-versions.sh << 'EOF'
#!/bin/bash

echo "Testing ecmwflibs with Python 3.12..."
source /home/vscode/venv-py312/bin/activate
python -m pip install -e .
python -m pytest tests/ -v
deactivate

echo "Testing ecmwflibs with Python 3.13..."
source /home/vscode/venv-py313/bin/activate  
python -m pip install -e .
python -m pytest tests/ -v
deactivate

echo "All tests completed!"
EOF

chmod +x test-all-versions.sh

# Create build script for wheels
cat > build-wheels.sh << 'EOF'
#!/bin/bash

echo "Building wheels for Python 3.12 and 3.13..."

# Clean previous builds
rm -rf build/ dist/ *.egg-info/

# Build for Python 3.12
echo "Building wheel for Python 3.12..."
source /home/vscode/venv-py312/bin/activate
python -m build --wheel
deactivate

# Build for Python 3.13  
echo "Building wheel for Python 3.13..."
source /home/vscode/venv-py313/bin/activate
python -m build --wheel
deactivate

echo "Wheels built successfully!"
ls -la dist/
EOF

chmod +x build-wheels.sh

# Verify installations
echo "Verifying Python installations..."
python3.12 --version
python3.13 --version

echo "Verifying ECMWF libraries..."
pkg-config --exists eccodes && echo "✓ eccodes found" || echo "✗ eccodes not found"
pkg-config --exists magics && echo "✓ magics found" || echo "✗ magics not found"

echo ""
echo "Development environment setup complete!"
echo ""
echo "Available commands:"
echo "  py312          - Activate Python 3.12 virtual environment"
echo "  py313          - Activate Python 3.13 virtual environment"
echo "  ./test-all-versions.sh  - Test with both Python versions"
echo "  ./build-wheels.sh       - Build wheels for both Python versions"
echo ""
echo "To get started:"
echo "  1. Run 'py312' or 'py313' to activate a Python environment"
echo "  2. Run 'pip install -e .' to install ecmwflibs in development mode"
echo "  3. Run 'python -m pytest tests/' to run tests"
echo ""