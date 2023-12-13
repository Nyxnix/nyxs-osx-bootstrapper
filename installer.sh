#!/bin/bash
# Nyx's OSX bootstrapper

set -euo pipefail
IFS=$'n\t'

# Install xcode
if ! command -v xcode-select &>/dev/null; then
    echo "Xcode Command Line Tools not found. Installing..."
    xcode-select --install || true
else
    echo "Xcode Command Line Tools already installed."
fi

SUDO_USER=$(whoami)

# Install brew
if ! command -v brew >/dev/null; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
    echo "Homebrew is already installed."
fi

brew update && brew upgrade

echo "install gnu tools and utilities"
# GNU core utilities
brew install coreutils
brew install gnu-sed
brew install gnu-tar
brew install gnu-indent
brew install gnu-which

# GNU tools
brew install findutils

# Install stuff
# I had this written as an array but im too lazy to figure out why it wasnt working so fuck it we do it manually
echo "Installing cask apps..."

brew install librewolf --cask --no-quarantine
brew install rectangle --cask
brew install iterm2 --cask
brew install linearmouse --cask
brew install aldente --cask
brew install appcleaner --cask
brew install the-unarchiver --cask
brew install hot --cask
brew install discord --cask
brew install spotify --cask
brew install anki --cask

echo "Installing packages..."

brew install ffmpeg
brew install git
brew install python3
brew install wget
brew install yt-dlp
brew install neofetch
brew install gh
brew install neovim
brew install node

echo "Installing Python packages..."
sudo -u $SUDO_USER pip3 install --upgrade pip
sudo -u $SUDO_USER pip3 install --upgrade setuptools
sudo -u $SUDO_USER pip3 install virtualenv
sudo -u $SUDO_USER pip3 install virtualenvwrapper

echo "Cleaning up"
brew cleanup
echo "Ask the doctor"
brew doctor

echo "Installing nvim configs"
# clone config files
gh auth login # login since the repo is private
mkdir ~/.config/nvim && cd ~/.config/nvim
git clone https://github.com/Nyxnix/nyx-nvim

# TODO: replace the above with a public dotfile repo eventually

echo "OSX bootstrapping done"
