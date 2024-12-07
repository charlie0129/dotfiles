#!/bin/bash

SCRIPT_DIR="$(dirname "${BASH_SOURCE}")"
cd "${SCRIPT_DIR}" || exit 1

dufs --completions zsh >dufs.zsh
k9s completion zsh >k9s.zsh
cat $HOME/.bun/_bun >bun.zsh
pm2 completion >pm2.zsh
