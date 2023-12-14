#!/bin/bash
################################################################################
# Nyx's OSX bootstrapper
################################################################################

set -euo pipefail
IFS=$'n\t'

################################################################################
# Install xcode
################################################################################

echo "###################"
echo "Installing xcode..."
echo "###################"

if ! command -v xcode-select &>/dev/null; then
    echo "Xcode Command Line Tools not found. Installing..."
    xcode-select --install || true
else
    echo "Xcode Command Line Tools already installed."
fi

SUDO_USER=$(whoami)

################################################################################
# Install brew
################################################################################

echo "##################"
echo "Installing brew..."
echo "##################"

if ! command -v brew >/dev/null; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
    echo "Homebrew is already installed."
fi

brew update && brew upgrade

################################################################################
# OMZ install
################################################################################

echo "#######################"
echo "Installing Oh My Zsh..."
echo "#######################"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

################################################################################
# GNU core utilities
################################################################################

echo "#####################################"
echo "Installing GNU tools and utilities..."
echo "#####################################"

brew install coreutils
brew install gnu-sed
brew install gnu-tar
brew install gnu-indent
brew install gnu-which

# GNU tools
brew install findutils

################################################################################
# Install stuff
################################################################################
echo "###########################"
echo "Installing brew packages..."
echo "###########################"

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
brew install surfshark --cask
brew install parallels --cask

brew install ffmpeg
brew install git
brew install python3
brew install wget
brew install yt-dlp
brew install neofetch
brew install gh
brew install neovim
brew install node
brew install amethyst
brew install tmux

echo "#############################"
echo "Installing Python packages..."
echo "#############################"

sudo -u $SUDO_USER pip3 install --upgrade pip
sudo -u $SUDO_USER pip3 install --upgrade setuptools
sudo -u $SUDO_USER pip3 install virtualenv
sudo -u $SUDO_USER pip3 install virtualenvwrapper

echo "###########"
echo "Cleaning up"
echo "###########"
brew cleanup
echo "##############"
echo "Ask the doctor"
echo "##############"
brew doctor

################################################################################
# Config
################################################################################

echo "#####################"
echo "Installing configs..."
echo "#####################"

# programs to grab configs for
# iterm2
# nvim
# ~/.zshrc
# linearmouse

# Download dotfiles and moving to .config folder
# git clone <URL>
# cd <REPO_FOLDER>
# mv */!(.zshrc|.oh-my-zsh|.local) ~/.config/
# cd .. && rm -r <REPO FOLDER>
# mv .oh-my-zsh ~/
# mv .local ~/

################################################################################
# System Preferences
################################################################################

echo "#################################"
echo "Changing macOS system settings..."
echo "#################################"

# System Preferences > General > Language & Region
defaults write ".GlobalPreferences_m" AppleLanguages -array en-US ja-JP
defaults write -globalDomain AppleLanguages -array en-US ja-JP

################################################################################
# System Preferences > Appearance
################################################################################

# Appearance: Auto
defaults write -globalDomain AppleInterfaceStyleSwitchesAutomatically -bool true
# Control Centre Modules > Sound > Always Show in Menu Bar
defaults write "com.apple.controlcenter" "NSStatusItem Visible Sound" -bool true
# Menu Bar Only > Spotlight > Don't Show in Menu Bar
defaults -currentHost write com.apple.Spotlight MenuItemHidden -int 1
# Control Centre Modules > Screen Mirroring > Don't Show in Menu Bar
defaults write "com.apple.airplay" showInMenuBarIfPresent -bool false

################################################################################
# System Preferences > Siri & Spotlight
################################################################################

#Ask Siri
defaults write com.apple.Siri SiriPrefStashedStatusMenuVisible -bool false
defaults write com.apple.Siri VoiceTriggerUserEnabled -bool false

################################################################################
# System Preferences > Desktop & Dock
################################################################################

# Dock > Minimize windows into application icon
defaults write com.apple.dock minimize-to-application -bool true
# Dock > Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true
# Dock > Automatically hide and show the Dock (duration)
defaults write com.apple.dock autohide-time-modifier -float 0.4
# Dock > Automatically hide and show the Dock (delay)
defaults write com.apple.dock autohide-delay -float 0
# Show recent applications in Dock
defaults write com.apple.dock "show-recents"  -bool false

################################################################################
# System Preferences > Keyboard
################################################################################

# Txt Input > Correct spelling automatically
defaults write -globalDomain NSAutomaticSpellingCorrectionEnabled -bool false
# Txt Input > Capitalise words automatically
defaults write -globalDomain NSAutomaticCapitalizationEnabled -bool false
# Txt Input > Add full stop with double-space
defaults write -globalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

################################################################################
# System Preferences > Trackpad
################################################################################

# Tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

################################################################################
# Finder > Preferences
################################################################################

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Show wraning before changing an extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Show wraning before removing from iCloud Drive
defaults write com.apple.finder FXEnableRemoveFromICloudDriveWarning -bool false
# Finder > View > As List
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# Finder > View > Show Path Bar
defaults write com.apple.finder ShowPathbar -bool true

# Kill affected apps
for app in "Dock" "Finder"; do
  killall "${app}" > /dev/null 2>&1
done

clear
echo "OSX bootstrapping done! Some changes may reqire a logout/reboot to take effect."
