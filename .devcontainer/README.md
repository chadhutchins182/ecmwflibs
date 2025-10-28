# ECMWF Libraries Development Container# Development Container for ECMWF Libraries



This dev container provides a complete development environment for the ecmwflibs project with:This devcontainer provides a complete development environment for working on the ecmwflibs project.



## Included Software## 🔄 UPDATED CONFIGURATION



- **Base Image**: Ubuntu 22.04This container has been updated to use a more reliable and faster setup:

- **Python**: 3.12 (default) and 3.13 available- **Base Image**: Microsoft's pre-built Python 3.12 dev container image

- **ECMWF Libraries**:- **Simplified Setup**: Automated installation of system dependencies

  - ecCodes 2.44.0 (built from source)- **Better Reliability**: Reduced build times and fewer potential failure points

  - Magics 4.16.0 (built from source)

- **Development Tools**: ## Features

  - pytest, black, isort, pylint, mypy

  - VS Code extensions for Python development- **Python 3.12**: Latest stable Python with full development tools

  - Git and GitHub CLI- **ECMWF Libraries**: System packages for eccodes and related libraries

- **Development Tools**: pytest, black, isort, pylint, mypy, tox

## Getting Started- **VS Code Extensions**: Python, C++, Git, and formatting extensions pre-configured

- **Build Tools**: Complete C/C++ toolchain for compiling extensions

1. Open the project in VS Code

2. When prompted, click "Reopen in Container"## Getting Started

3. Wait for the container to build (first time only)

4. The package will be automatically installed in development mode1. **Open in Dev Container**: Use VS Code's "Reopen in Container" command

5. Start developing!2. **Wait for Setup**: The container will automatically install dependencies

3. **Install in Development Mode**: `pip install -e .`

## Available Commands4. **Run Tests**: `pytest`



- `pytest` - Run tests## Available Commands

- `pytest --cov=ecmwflibs --cov-report=html` - Run tests with coverage

- `black .` - Format codeAfter setup, you'll have access to:

- `isort .` - Sort imports- `pytest` - Run the test suite

- `pylint ecmwflibs/` - Lint code- `black` - Format your Python code

- `python -m ecmwflibs versions` - Check ECMWF library versions- `pylint` - Lint your code for issues  

- `mypy` - Type checking

## Environment Variables- `tox` - Test across multiple environments



The container sets up the following environment variables:## System Libraries

- `ECCODES_DIR=/usr/local`

- `MAGICS_HOME=/usr/local`The container includes all necessary system dependencies:

- `PYTHONPATH=/workspaces/ecmwflibs`- ECMWF eccodes library (via system packages)

- NetCDF, HDF5, PROJ, GEOS libraries

## Building- Complete C/C++/Fortran toolchain

- CMake and build tools

The container builds ecCodes and Magics from source to ensure compatibility and the latest features. This takes some time on first build but provides a reliable development environment.- Git and development utilities

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