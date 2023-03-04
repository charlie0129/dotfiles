#!/usr/bin/env bash

# cd into where this script lives
cd "$(dirname "${BASH_SOURCE}")" || exit 1

source "../../bin/util/confirm.sh"

echo "===== Display Configurations ====="

confirm "Enable HiDPI display modes (requires restart)" &&
    sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

echo "That's all for now. You may need to restart the corresponding apps, or even your computer for the changes to take effect."
exit 0
