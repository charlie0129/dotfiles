#!/usr/bin/env bash

# cd into where this script lives
cd "$(dirname "${BASH_SOURCE}")" || exit 1

source "../../bin/util/confirm.sh"

echo "===== App Store Configurations ====="

confirm "Enable the WebKit Developer Tools in the Mac App Store" &&
    defaults write com.apple.appstore WebKitDeveloperExtras -bool true

confirm "Enable Debug Menu in the Mac App Store" &&
    defaults write com.apple.appstore ShowDebugMenu -bool true

confirm "Disable the automatic update check" &&
    defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool false

confirm "Do not install system data files & security updates" &&
    defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 0

confirm "Do not automatically download apps purchased on other Macs" &&
    defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 0

confirm "Turn off app auto-update" &&
    defaults write com.apple.commerce AutoUpdate -bool false

echo "That's all for now. You may need to restart the corresponding apps, or even your computer for the changes to take effect."
exit 0
