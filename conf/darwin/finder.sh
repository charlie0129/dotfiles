#!/usr/bin/env bash

# cd into where this script lives
cd "$(dirname "${BASH_SOURCE}")" || exit 1

source "../../bin/util/confirm.sh"

echo "===== Finder Configurations ====="

confirm "Allow quitting Finder via ⌘ + Q" &&
    defaults write com.apple.finder QuitMenuItem -bool true

confirm "Set Computer as the default location for new Finder windows" &&
    defaults write com.apple.finder NewWindowTarget -string "PfDe"

confirm "Show hidden files by default" &&
    defaults write com.apple.finder AppleShowAllFiles -bool true

confirm "Show all filename extensions" &&
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
# defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
# defaults write com.apple.finder ShowPathbar -bool true

confirm "Display full POSIX path as Finder window title" &&
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

confirm "Keep folders on top when sorting by name" &&
    defaults write com.apple.finder _FXSortFoldersFirst -bool true

confirm "When performing a search, search the current folder by default" &&
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

confirm "Disable the warning when changing a file extension" &&
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network or USB volumes
# defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

confirm "Disable disk image verification" &&
    defaults write com.apple.frameworks.diskimages skip-verify -bool true &&
    defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true &&
    defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

confirm "Show item info near icons on the desktop and in other icon views" &&
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist &&
    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist &&
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

confirm "Enable snap-to-grid for icons on the desktop and in other icon views" &&
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist &&
    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist &&
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
confirm "Use list view in all Finder windows by default" &&
    defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Disable the warning before emptying the Trash
# defaults write com.apple.finder WarnOnEmptyTrash -bool false

confirm "Show the ~/Library and /Volumes folder" &&
    chflags nohidden ~/Library &&
    xattr -d com.apple.FinderInfo ~/Library &&
    sudo chflags nohidden /Volumes

echo "That's all for now. You may need to restart the corresponding apps, or even your computer for the changes to take effect."
exit 0
