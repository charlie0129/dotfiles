#!/usr/bin/env bash

# Install crontabs
echo "Installing crontabs for root..."
# Install *root* crontab for darwin/linux
CRONFILE="${HOME}/dotfiles/cron/${OS}/root.conf"
if [ -f "${CRONFILE}" ] && [ "${OS}" = "darwin" ] || [ "${OS}" = "linux" ]; then
    if [ "$EUID" -ne 0 ]; then
        sudo crontab "${CRONFILE}"
    else
        crontab "${CRONFILE}"
    fi
fi