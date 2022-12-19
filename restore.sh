#!/usr/bin/env bash

# Must have a parameter
if [ -z "$1" ]; then
    echo "Usage: $0 <backup_archive>"
    echo "This script restores a dotfiles backup archive to your home directory and runs bootstrap.sh"
    exit 1
fi

BACKUP_ARCHIVE="$1"

# BACKUP_ARCHIVE must exist
if [ ! -f "${BACKUP_ARCHIVE}" ]; then
    echo "${BACKUP_ARCHIVE} does not exist"
    exit 1
fi

# Restore location. `dotfiles`` will be restored to this location.
RESTORE_DIR="${HOME}"

mkdir -p "$RESTORE_DIR"

tar xf "${BACKUP_ARCHIVE}" --directory="${RESTORE_DIR}"|| exit 1

bash "${RESTORE_DIR}/dotfiles/bootstrap.sh" -f

echo "Your custom config have been restored"
