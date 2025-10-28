# Development Container for ECMWF Libraries

This devcontainer provides a complete development environment for working on the ecmwflibs project.

## 🔄 UPDATED CONFIGURATION

This container has been updated to use a more reliable and faster setup:
- **Base Image**: Microsoft's pre-built Python 3.12 dev container image
- **Simplified Setup**: Automated installation of system dependencies
- **Better Reliability**: Reduced build times and fewer potential failure points

## Features

- **Python 3.12**: Latest stable Python with full development tools
- **ECMWF Libraries**: System packages for eccodes and related libraries
- **Development Tools**: pytest, black, isort, pylint, mypy, tox
- **VS Code Extensions**: Python, C++, Git, and formatting extensions pre-configured
- **Build Tools**: Complete C/C++ toolchain for compiling extensions

## Getting Started

1. **Open in Dev Container**: Use VS Code's "Reopen in Container" command
2. **Wait for Setup**: The container will automatically install dependencies
3. **Install in Development Mode**: `pip install -e .`
4. **Run Tests**: `pytest`

## Available Commands

After setup, you'll have access to:
- `pytest` - Run the test suite
- `black` - Format your Python code
- `pylint` - Lint your code for issues  
- `mypy` - Type checking
- `tox` - Test across multiple environments

## System Libraries

The container includes all necessary system dependencies:
- ECMWF eccodes library (via system packages)
- NetCDF, HDF5, PROJ, GEOS libraries
- Complete C/C++/Fortran toolchain
- CMake and build tools
- Git and development utilities

## VS Code Configuration

The container is pre-configured with:
- Python language server and debugging
- Code formatting (Black, isort) 
- Linting (pylint, mypy)
- C++ development tools
- Git integration with GitLens

## Testing

```bash
# Run all tests
pytest

# Run tests with coverage
pytest --cov=ecmwflibs --cov-report=html

# Run specific tests
pytest tests/test_specific.py
```

## Building and Distribution

```bash
# Build the package
python -m build

# Install in development mode (editable)
pip install -e .
# Check package
twine check dist/*
```

## Troubleshooting

If you encounter issues:

1. **Rebuild Container**: Use VS Code command palette → "Dev Containers: Rebuild Container"
2. **Check Setup**: Run `bash .devcontainer/setup.sh` manually if needed
3. **View Logs**: Check the "Dev Containers" output panel in VS Code
4. **Container Info**: The setup script will show available commands when complete

## Files in This Directory

- `devcontainer.json` - Main container configuration
- `setup.sh` - Automated setup script 
- `Dockerfile.backup` - Original Dockerfile (backup)
- `post-create.sh` - Original setup script (backup)
- `README.md` - This file

The new configuration is more reliable and faster than the previous custom Dockerfile approach.