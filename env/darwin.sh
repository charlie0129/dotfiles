#!/usr/bin/env bash

# This list is inserted before PATH
PATH_BEFORE=(
    # Homebrew
    /usr/local/bin
    /usr/local/sbin
    # bin in this repo
    $HOME/dotfiles/bin/darwin
    # Homebrew installed OpenJDK
    /usr/local/opt/openjdk/bin
)

# This list is appended after PATH
PATH_AFTER=(
    # Visual Studio Code
    /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin
    # Sublime Text
    /Applications/Sublime\ Text.app/Contents/SharedSupport/bin
)

PATH="$(IFS=:; echo "${PATH_BEFORE[*]}"):$PATH:$(IFS=:; echo "${PATH_AFTER[*]}")"
export PATH

# HomeBrew
export HOMEBREW_NO_AUTO_UPDATE=true
# export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles

# Homebrew installed OpenJDK 17
export JAVA_HOME=$(/usr/libexec/java_home -v 17)