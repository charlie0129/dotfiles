#!/usr/bin/env bash

# This list is inserted before PATH
PATH_BEFORE=(
    # bin in this repo
    $DOTFILES_ROOT/bin/darwin
    # Homebrew x86_64. I am not using Homebrew anymore. Just keep it here if anyone needs it.
    /usr/local/bin
    /usr/local/sbin
    # Homebrew arm64. I am not using Homebrew anymore. Just keep it here if anyone needs it.
    /opt/homebrew/bin
    /opt/homebrew/sbin
    # I use nix as my package manger now, installed using https://github.com/DeterminateSystems/nix-installer.
    # The installer configures PATH globally in /etc/zshrc, /etc/zshenv, /etc/bashrc
    # so I don't need to set it here.
    # OrbStack
    $HOME/.orbstack/bin
)

# This list is appended after PATH
PATH_AFTER=(
    # `code` for Visual Studio Code
    /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin
    # `subl` for Sublime Text
    /Applications/Sublime\ Text.app/Contents/SharedSupport/bin
    # `cot` for CotEditor
    /Applications/CotEditor.app/Contents/SharedSupport/bin
)

PATH="$(IFS=:; echo "${PATH_BEFORE[*]}"):$PATH:$(IFS=:; echo "${PATH_AFTER[*]}")"
export PATH

# HomeBrew (kept for reference)
# No I don't want auto update, go away.
export HOMEBREW_NO_AUTO_UPDATE=true
# Set up mirror if needed
# export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
