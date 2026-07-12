#!/usr/bin/env bash

# cd into where this script lives
cd "$(dirname "${BASH_SOURCE}")" || exit 1

source "../bin/util/confirm.sh"

OS=$(uname -s | tr '[:upper:]' '[:lower:]')

CRONFILE="$OS/root.conf"

CRONCONTENT="$(cat $CRONFILE | sed "s|\$DOTFILES_ROOT|$DOTFILES_ROOT|g")"

# Install *root* crontab for darwin/linux
if [ -f "$CRONFILE" ] && [ "$OS" = "darwin" ] || [ "$OS" = "linux" ]; then
    echo "========== CRONTAB START =========="
    echo "$CRONCONTENT"
    echo "========== CRONTAB END =========="

    if [ "$EUID" -ne 0 ]; then
        confirm "The above crontab will be installed for root, continue" &&
            echo "$CRONCONTENT" | sudo crontab -
    else
        confirm "The above crontab will be installed for root, continue" &&
            echo "$CRONCONTENT" | crontab -
    fi
fi

exit 0
