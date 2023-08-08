#!/bin/bash

# This script will look for any installed versions of Python on a Unix or Linux based PC and uninstall them safely.

# Get a list of all the installed Python versions.
versions=$(python -c "import sys; print(list(filter(lambda x: x.startswith('python'), sys.path)))")

# For each installed Python version, uninstall it.
for version in $versions; do
  # Check if the Python version is installed in a virtual environment.
  venv_path=$(python -c "import venv; print(venv._get_distribution('python')['home']))"
  if [ -d "$venv_path" ]; then
    echo "Uninstalling Python ${version} virtual environment..."
    echo "Are you sure you want to uninstall this virtual environment? (y/n)"
    read -r response
    if [[ "$response" == "y" ]]; then
      rm -rf $venv_path
    fi
  fi

  # Check if the Python version is installed in a sandboxed environment.
  sandboxed_path=$(python -c "import sandbox; print(sandbox.get_sandboxed_path('python')['home']))"
  if [ -d "$sandboxed_path" ]; then
    echo "Uninstalling Python ${version} sandboxed environment..."
    echo "Are you sure you want to uninstall this sandboxed environment? (y/n)"
    read -r response
    if [[ "$response" == "y" ]]; then
      rm -rf $sandboxed_path
    fi
  fi

  # Check if the Python version is installed using Conda.
  conda_path=$(which python${version})
  if [ -n "$conda_path" ]; then
    echo "Uninstalling Python ${version} Conda installation..."
    echo "Are you sure you want to uninstall this Conda installation? (y/n)"
    read -r response
    if [[ "$response" == "y" ]]; then
      conda uninstall python${version}
    fi
  fi

  # Check if the Python version is installed using Brew.
  brew_path=$(which python${version})
  if [ -n "$brew_path" ]; then
    echo "Uninstalling Python ${version} Brew installation..."
    echo "Are you sure you want to uninstall this Brew installation? (y/n)"
    read -r response
    if [[ "$response" == "y" ]]; then
      brew uninstall python${version}
    fi
  fi

  # Uninstall the system level Python installation.
  echo "Uninstalling Python ${version} system level installation..."
  sudo apt-get remove --purge python${version}
done

# Print a message indicating that the script has completed successfully.
echo "Done!"
