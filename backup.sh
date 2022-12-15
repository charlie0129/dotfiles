#!/usr/bin/env bash

BACKUP_STORE="$HOME/.dotfiles-backup"
BACKUP_DATE=$(date +"%Y%m%dT%H%M%S%z")
BACKUP_DIST="${BACKUP_STORE}/${BACKUP_DATE}"

# cd into where this script lives
SCRIPT_DIR="$(dirname "${BASH_SOURCE}")"
cd "${SCRIPT_DIR}" || exit 1

# Make directory for backup
cp "restore.sh" "${BACKUP_STORE}"

BACKUP_DIRS=(
    "dotfiles"
)

BACKUP_FILES=(
    ".zsh_history"
)

# tar BACKUP_DIST
tar czf "${BACKUP_DIST}.tar.gz" --directory="${HOME}" "${BACKUP_DIRS[@]}" "${BACKUP_FILES[@]}" || exit 1

echo "Your custom config have been backed up to ${BACKUP_DIST}.tar.gz"
