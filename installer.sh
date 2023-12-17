#!/bin/bash
################################################################################
# Nyx's OSX bootstrapper
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

# Add brew to path (not sure why its not still there after script)
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/nyx/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

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
brew install alacritty --cask
brew install linearmouse --cask
brew install aldente --cask
brew install appcleaner --cask
brew install the-unarchiver --cask
brew install discord --cask
brew install spotify --cask
brew install anki --cask
brew install surfshark --cask

brew install ffmpeg
brew install git
brew install python3
brew install wget
brew install yt-dlp
brew install neofetch
brew install gh
brew install neovim
brew install node
brew install tmux
brew install bash

# Install bashtop
python3 -m pip install psutil
git clone https://github.com/aristocratos/bashtop.git
cd bashtop
sudo make install
cd ..
rm -r bashtop

echo "###########"
echo "Cleaning up"
echo "###########"

brew cleanup

echo "##############"
echo "Ask the doctor"
echo "##############"

brew doctor

################################################################################
# Yabai WM
################################################################################

echo "##########################################"
echo "Installing Yabai WM, skhd, and spacebar..."
echo "##########################################"

brew install koekeishiya/formulae/yabai
brew install koekeishiya/formulae/skhd
brew install cmacrae/formulae/spacebar

################################################################################
# Config
################################################################################

echo "#####################"
echo "Installing configs..."
echo "#####################"

git clone https://github.com/Nyxnix/osx-dotfiles
cd osx-dotfiles
# check if .config exists
if [ -d "~/.config" ]; then
  echo "~/.config does exist."
  mkdir ~/.config
fi

# Move files to right places
mv .config ~/
mv .skhdrc ~/
mv .zshrc ~/
mv nyx.zsh-theme ~/.oh-my-zsh/themes

# Step out and clean up
cd ..
rm -r osx-dotfiles

# Install packer for nvim
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Get smctemp and compile for menubar script
git clone https://github.com/narugit/smctemp
cd smctemp
sudo make install

# Get fonts for terminal display and menubar
brew tap homebrew/cask-fonts
brew tap corgibytes/cask-fonts
brew install font-awesome-terminal-fonts
brew install font-fontawesome

################################################################################
# System Preferences
################################################################################

echo "#################################"
echo "Changing macOS system settings..."
echo "#################################"

# yes i know this part sucks to read, im not fixing it :)

# System Preferences > General > Language & Region
defaults write ".GlobalPreferences_m" AppleLanguages -array en-US ja-JP
defaults write -globalDomain AppleLanguages -array en-US ja-JP
# Appearance: Auto
defaults write -globalDomain AppleInterfaceStyleSwitchesAutomatically -bool true
# Control Centre Modules > Sound > Always Show in Menu Bar
defaults write "com.apple.controlcenter" "NSStatusItem Visible Sound" -bool true
# Menu Bar Only > Spotlight > Don't Show in Menu Bar
defaults -currentHost write com.apple.Spotlight MenuItemHidden -int 1
#Ask Siri
defaults write com.apple.Siri SiriPrefStashedStatusMenuVisible -bool false
defaults write com.apple.Siri VoiceTriggerUserEnabled -bool false
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
# Txt Input > Capitalise words automatically
defaults write -globalDomain NSAutomaticCapitalizationEnabled -bool false
# Txt Input > Add full stop with double-space
defaults write -globalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
# Tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Show warning before changing an extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Show warning before removing from iCloud Drive
defaults write com.apple.finder FXEnableRemoveFromICloudDriveWarning -bool false
# Finder > View > As List
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# Finder > View > Show Path Bar
defaults write com.apple.finder ShowPathbar -bool true

# add new settings changes for yabai
# Accessibility > Display > Reduce Motion
defaults write com.apple.accessibility ReduceMotionEnabled -bool true

# Start yabai, skhd, spacebar
yabai --start-service
skhd --start-service
brew services start spacebar

# Kill affected apps
for app in "Dock" "Finder"; do
  killall "${app}" > /dev/null 2>&1
done

clear
echo "OSX bootstrapping done! Some changes may reqire a logout/reboot to take effect."
echo "Run the following commands to add brew to your path"
echo "(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/nyx/.zprofile"
echo "eval "$(/opt/homebrew/bin/brew shellenv)""
