#!/bin/bash

# Test script for the development container
# This script validates that the ECMWF libraries are properly installed

echo "🧪 Testing ECMWF Libraries Development Environment"
echo "=================================================="
echo ""

# Test Python versions
echo "📍 Python Versions:"
echo "  Default Python: $(python --version 2>&1)"
echo "  Python 3.12: $(python3.12 --version 2>&1)"
echo "  Python 3.13: $(python3.13 --version 2>&1 || echo 'Not available')"
echo ""

# Test ECMWF libraries
echo "📍 ECMWF Libraries:"
echo "  ecCodes version: $(codes_info -v 2>/dev/null || echo 'Command not found - check installation')"
echo "  Magics installed: $(python -c 'import Magics; print("✅ Available")' 2>/dev/null || echo '❌ Not available via Python')"
echo ""

# Test environment variables
echo "📍 Environment Variables:"
echo "  ECCODES_DIR: ${ECCODES_DIR:-'Not set'}"
echo "  MAGICS_HOME: ${MAGICS_HOME:-'Not set'}"
echo "  PYTHONPATH: ${PYTHONPATH:-'Not set'}"
echo ""

# Test Python packages
echo "📍 Python Development Tools:"
for pkg in pytest black isort pylint mypy numpy cffi; do
    python -c "import $pkg; print('  ✅ $pkg')" 2>/dev/null || echo "  ❌ $pkg not available"
done
echo ""

# Test ecmwflibs package
echo "📍 ecmwflibs Package:"
if python -c "import ecmwflibs; print('  ✅ ecmwflibs imported successfully')" 2>/dev/null; then
    python -c "import ecmwflibs; print('  📦 Version:', ecmwflibs.__version__)" 2>/dev/null
    python -m ecmwflibs versions 2>/dev/null || echo "  ⚠️  Unable to get library versions (C extension may need building)"
else
    echo "  ❌ ecmwflibs not available - run 'pip install -e .' first"
fi
echo ""

echo "🎯 Development Environment Ready!"
echo "   Run 'pip install -e .' to install ecmwflibs in development mode"
echo "   Run 'pytest' to run the test suite"