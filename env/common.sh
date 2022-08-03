#!/usr/bin/env bash

# This list is inserted before PATH
PATH_BEFORE=(
    # User-specific bin
    $HOME/bin
    $HOME/.local/bin
    # bin in this repo
    $HOME/dotfiles/bin/common
    # Go bin
    $HOME/go/bin
)

# This list is appended after PATH
PATH_AFTER=(
    /usr/local/go/bin
)

# Apply changes to PATH
PATH="$(IFS=:; echo "${PATH_BEFORE[*]}"):$PATH:$(IFS=:; echo "${PATH_AFTER[*]}")"
export PATH

# GPG
export GPG_TTY=$(tty)

# Go proxy in China
export GOPROXY=https://goproxy.cn