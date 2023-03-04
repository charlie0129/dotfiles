#!/usr/bin/env bash

# cd into where this script lives
SCRIPT_DIR="$(dirname "${BASH_SOURCE}")"
cd "${SCRIPT_DIR}" || exit 1

for i in systemd-hooks/system-sleep/*; do
    chmod +x "${i}"
    sudo ln -sf "$PWD/$i" /usr/lib/systemd/system-sleep/
done
