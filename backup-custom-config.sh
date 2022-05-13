#!/usr/bin/env bash

BACKUP_DIR="$HOME/.custom-config-backup"

# cd into where this script lives
SCRIPT_DIR="$(dirname "${BASH_SOURCE}")"
cd "${SCRIPT_DIR}" || exit 1

mkdir -p "${BACKUP_DIR}/alias"
mkdir -p "${BACKUP_DIR}/bin"
mkdir -p "${BACKUP_DIR}/env"

cp "alias/custom.sh" "${BACKUP_DIR}/alias"
cp -r "bin/custom" "${BACKUP_DIR}/bin"
cp "env/custom.sh" "${BACKUP_DIR}/env"

echo "Your custom config have been backed up to ${BACKUP_DIR}"
