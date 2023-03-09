#!/usr/bin/env bash

# cd into where this script lives
cd "$(dirname "${BASH_SOURCE}")" || exit 1

source "../bin/util/confirm.sh"

OS=$(uname -s | tr '[:upper:]' '[:lower:]')

CRONFILE="$OS/root.conf"

# Install *root* crontab for darwin/linux
if [ -f "$CRONFILE" ] && [ "$OS" = "darwin" ] || [ "$OS" = "linux" ]; then
    echo "========== CRONTAB START =========="
    cat "$CRONFILE"
    echo "========== CRONTAB END =========="

    if [ "$EUID" -ne 0 ]; then
        confirm "The above crontab will be installed for root, continue" &&
            sudo crontab "$CRONFILE"
    else
        confirm "The above crontab will be installed for root, continue" &&
            crontab "$CRONFILE"
    fi
fi

exit 0
