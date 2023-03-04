#!/usr/bin/env bash

# cd into where this script lives
cd "$(dirname "${BASH_SOURCE}")" || exit 1

source "../../bin/util/confirm.sh"

echo "===== Dock Configurations ====="

confirm "Set the icon size of Dock items to 36 pixels" &&
    defaults write com.apple.dock tilesize -int 36

confirm "Enable spring loading for all Dock items" &&
    defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

confirm "Show indicator lights for open applications in the Dock" &&
    defaults write com.apple.dock show-process-indicators -bool true

confirm "Remove the auto-hiding Dock delay and speed up the animation when hiding/showing the Dock" &&
    defaults write com.apple.dock autohide-delay -float 0 &&
    defaults write com.apple.Dock autohide-time-modifier -float 0.25

confirm "Make Dock icons of hidden applications translucent" &&
    defaults write com.apple.dock showhidden -bool true

# Don’t show recent applications in Dock
# defaults write com.apple.dock show-recents -bool false

# Disable the Launchpad gesture (pinch with thumb and three fingers)
#defaults write com.apple.dock showLaunchpadGestureEnabled -int 0

echo "That's all for now. You may need to restart the corresponding apps, or even your computer for the changes to take effect."
exit 0
