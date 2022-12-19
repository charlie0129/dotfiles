#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "${BASH_SOURCE}")"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

# Install crontabs
echo "Installing crontabs for root..."
# Install *root* crontab for darwin/linux
CRONFILE="$SCRIPT_DIR/$OS/root.conf"
if [ -f "$CRONFILE" ] && [ "$OS" = "darwin" ] || [ "$OS" = "linux" ]; then
    if [ "$EUID" -ne 0 ]; then
        sudo crontab "$CRONFILE"
    else
        crontab "$CRONFILE"
    fi
fi