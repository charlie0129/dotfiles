#!/usr/bin/env bash

# This file is not tracked by git. You can put env definitions that are specific
# to this computer here, without being synced to upstream or other computers.

# This list is inserted before PATH
PATH_BEFORE=(
    # custom bin in this repo, i.e. bin/custom
    $HOME/dotfiles/bin/custom
)

# This list is appended after PATH
PATH_AFTER=(
    /Volumes/MacTeX2025Portable/bin
    /Volumes/MacTeX2025Portable/texlive/2025/bin/universal-darwin
    $HOME/src/github.com/brendangregg/FlameGraph
)

PATH="$(IFS=:; echo "${PATH_BEFORE[*]}"):$PATH:$(IFS=:; echo "${PATH_AFTER[*]}")"
export PATH

export GOPRIVATE="dev.aminer.cn/*"
