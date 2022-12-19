#!/usr/bin/env bash

# This list is inserted before PATH
PATH_BEFORE=(
    # bin in this repo
    $DOTFILES_ROOT/bin/linux
)

# This list is appended after PATH
PATH_AFTER=(
)

PATH="$(IFS=:; echo "${PATH_BEFORE[*]}"):$PATH:$(IFS=:; echo "${PATH_AFTER[*]}")"
export PATH
