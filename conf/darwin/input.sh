#!/usr/bin/env bash

# cd into where this script lives
cd "$(dirname "${BASH_SOURCE}")" || exit 1

source "../../bin/util/confirm.sh"

echo "===== Input Configurations ====="

confirm "Enable trackpad tap to click for this user and for the login screen" &&
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true &&
    defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1 &&
    defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

confirm "Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)" &&
    defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

confirm "Set faster keyboard repeat rate and lower initial delay" &&
    defaults write NSGlobalDomain KeyRepeat -int 2 &&
    defaults write NSGlobalDomain InitialKeyRepeat -int 15

confirm "Set English (US) language, CNY currency, and metric units" &&
    defaults write NSGlobalDomain AppleLanguages -array "en" &&
    defaults write NSGlobalDomain AppleLocale -string "en_US@currency=CNY" &&
    defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters" &&
    defaults write NSGlobalDomain AppleMetricUnits -bool true

confirm "Show language menu in the top right corner of the boot screen" &&
    sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true

echo "That's all for now. You may need to restart the corresponding apps, or even your computer for the changes to take effect."
exit 0
