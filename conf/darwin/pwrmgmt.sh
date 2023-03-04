#!/usr/bin/env bash

# cd into where this script lives
cd "$(dirname "${BASH_SOURCE}")" || exit 1

source "../../bin/util/confirm.sh"

echo "===== Power Management Configurations ====="

confirm "Disable hibernation" &&
    sudo pmset -a hibernatemode 0 &&
    sudo rm -rf /var/vm/sleepimage &&
    sudo mkdir /var/vm/sleepimage

confirm "Disable standby" &&
    sudo pmset -a standby 0

confirm "Disable autopoweroff" &&
    sudo pmset -a autopoweroff 0

confirm "Disable ttyskeepawake" &&
    sudo pmset -a ttyskeepawake 0

confirm "Disable proximitywake" &&
    sudo pmset -a proximitywake 0

confirm "Disable powernap" &&
    sudo pmset -a powernap 0

confirm "Disable acwake" &&
    sudo pmset -a acwake 0

confirm "Disable womp" &&
    sudo pmset -a womp 0

echo "That's all for now. You may need to restart the corresponding apps, or even your computer for the changes to take effect."
exit 0
