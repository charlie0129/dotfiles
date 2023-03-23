#!/usr/bin/env bash

# This list is inserted before PATH
PATH_BEFORE=(
    # Homebrew
    /usr/local/bin
    /usr/local/sbin
    # bin in this repo
    $DOTFILES_ROOT/bin/darwin
    # Homebrew-installed OpenJDK takes higher priority
    /usr/local/opt/openjdk/bin
    # Homebrew-installed curl takes higher priority
    /usr/local/opt/curl/bin
)

# This list is appended after PATH
PATH_AFTER=(
    # `code` Visual Studio Code
    /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin
    # `subl` Sublime Text
    /Applications/Sublime\ Text.app/Contents/SharedSupport/bin
)

PATH="$(IFS=:; echo "${PATH_BEFORE[*]}"):$PATH:$(IFS=:; echo "${PATH_AFTER[*]}")"
export PATH

# HomeBrew
# No I don't want auto update, go away.
export HOMEBREW_NO_AUTO_UPDATE=true
# Set up mirror if needed
# export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles

# Set Homebrew-installed OpenJDK 17, change this accordingly
# export JAVA_HOME=$(/usr/libexec/java_home -v 17)
