#!/bin/bash

# Validation script to check that the development environment is working correctly

set -e

echo "🔍 Validating ECMWF Libraries Development Environment..."
echo ""

# Check Python version and installation
echo "✓ Python Version:"
python --version
echo ""

# Check key Python packages
echo "✓ Checking Python packages:"
python -c "
packages = [
    'pytest', 'black', 'pylint', 'mypy', 'tox', 
    'numpy', 'cffi', 'findlibs', 'eccodes'
]
for package in packages:
    try:
        __import__(package)
        print(f'  ✓ {package}')
    except ImportError:
        print(f'  ✗ {package} (not installed)')
"
echo ""

# Check system libraries
echo "✓ Checking system libraries:"
if command -v cmake >/dev/null 2>&1; then
    echo "  ✓ cmake"
else
    echo "  ✗ cmake"
fi

if command -v gcc >/dev/null 2>&1; then
    echo "  ✓ gcc"
else
    echo "  ✗ gcc"
fi

if command -v gfortran >/dev/null 2>&1; then
    echo "  ✓ gfortran"
else
    echo "  ✗ gfortran"
fi

if pkg-config --exists eccodes 2>/dev/null; then
    echo "  ✓ eccodes ($(pkg-config --modversion eccodes))"
else
    echo "  ✗ eccodes"
fi

if pkg-config --exists netcdf 2>/dev/null; then
    echo "  ✓ netcdf ($(pkg-config --modversion netcdf))"
else
    echo "  ✗ netcdf"
fi

echo ""

# Check if we can import key libraries
echo "✓ Testing ECMWF library imports:"
python -c "
try:
    import eccodes
    print('  ✓ eccodes module can be imported')
except ImportError as e:
    print(f'  ✗ eccodes import failed: {e}')

try:
    import cffi
    print('  ✓ cffi module can be imported')
except ImportError as e:
    print(f'  ✗ cffi import failed: {e}')

try:
    import numpy
    print('  ✓ numpy module can be imported')
except ImportError as e:
    print(f'  ✗ numpy import failed: {e}')
"

echo ""
echo "🎉 Environment validation complete!"
echo ""
echo "Next steps:"
echo "  1. Install ecmwflibs in development mode: pip install -e ."
echo "  2. Run the test suite: pytest"
echo "  3. Start developing!"