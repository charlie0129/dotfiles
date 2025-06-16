#!/usr/bin/env bash

# This list is inserted before PATH
PATH_BEFORE=(
    # bin in this repo
    $DOTFILES_ROOT/bin/darwin
    # Homebrew x86_64.
    /usr/local/bin
    /usr/local/sbin
    # Homebrew arm64.
    /opt/homebrew/bin
    /opt/homebrew/sbin
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
# No attestations. It slows down my install.
export HOMEBREW_NO_VERIFY_ATTESTATIONS=1
# Set up mirror if needed
# export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
# If you want to fake the Homebrew-detected OS version, uncomment the following line.
# This is useful if you are using a unsupported macOS version and still want to use Homebrew bottles.
# export HOMEBREW_FAKE_MACOS=13.0
