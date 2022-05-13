#!/usr/bin/env bash

BACKUP_DIR="$HOME/.custom-config-backup"

# cd into where this script lives
SCRIPT_DIR="$(dirname "${BASH_SOURCE}")"
cd "${SCRIPT_DIR}" || exit 1

# Make sure SCRIPT_DIR is $HOME/dotfiles
if [ "${PWD}" != "${HOME}/dotfiles" ]; then
    echo "The whole dotfiles repo must be cloned to ${HOME}/dotfiles" 1>&2
    echo "Currently in ${PWD}" 1>&2
    exit 1
fi

cp "${BACKUP_DIR}/alias/custom.sh" "alias/custom.sh"
cp -r "${BACKUP_DIR}/bin/custom" "bin"
cp "${BACKUP_DIR}/env/custom.sh" "env/custom.sh"

echo "Your custom config have been restored"

# Do not track custom config
git update-index --skip-worktree alias/custom.sh env/custom.sh
