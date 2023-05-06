#!/usr/bin/env bash

BACKUP_STORE="$HOME/.dotfiles-backup"
BACKUP_DATE=$(date +"%Y%m%dT%H%M%S%z")
BACKUP_DIST="${BACKUP_STORE}/${BACKUP_DATE}"

# cd into where this script lives
SCRIPT_DIR="$(dirname "${BASH_SOURCE}")"
cd "${SCRIPT_DIR}" || exit 1

# Make directory for backup
mkdir -p "${BACKUP_STORE}" || exit 1
cp "restore.sh" "${BACKUP_STORE}"

BACKUP_DIRS=(
    "dotfiles"
)

BACKUP_FILES=(
    ".zsh_history"
)

SKIP_DIRS=(
    ".DS_Store"
    "._*"
    "dotfiles/dep/awesome-vimrc/temp_dirs"
)

# tar BACKUP_DIST
tar czf "${BACKUP_DIST}.tar.gz" \
    --directory="${HOME}" \
    "${SKIP_DIRS[@]/#/--exclude=}" \
    "${BACKUP_DIRS[@]}" "${BACKUP_FILES[@]}" || exit 1

echo "Your custom config have been backed up to ${BACKUP_DIST}.tar.gz"
echo "To restore this backup, run: bash $BACKUP_STORE/restore.sh ${BACKUP_DIST}.tar.gz"
