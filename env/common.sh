#!/usr/bin/env bash

# This list is inserted before PATH
PATH_BEFORE=(
    # User-specific bin
    $HOME/bin
    $HOME/.local/bin
    # bin in this repo
    $DOTFILES_ROOT/bin/common
    # Go bin
    $HOME/go/bin
    # Cargo bin
    $HOME/.cargo/bin
    # Bun bin
    $HOME/.bun/bin
    # Manually installed Go toolchain, if any
    /usr/local/go/bin
    # Manually installed Zig toolchain, if any
    /usr/local/zig
)

# This list is appended after PATH
PATH_AFTER=(
)

# Apply changes to PATH
PATH="$(IFS=:; echo "${PATH_BEFORE[*]}"):$PATH:$(IFS=:; echo "${PATH_AFTER[*]}")"
export PATH

# ========== ZSH ==========

# Path to oh-my-zsh installation.
export ZSH="$DOTFILES_ROOT/dep/ohmyzsh"

ZSH_DISABLE_COMPFIX=true

ZSH_THEME="powerlevel10k/powerlevel10k"

# Show prompt changes if mode changes in vi mode
VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true

# Disable bi-weekly auto-update checks for oh-my-zsh
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Customize zsh-autosuggestions settings. Enable completion.
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# ========== MISC ==========

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# try nvim, vim, vi, nano in order
for editor in nvim vim vi nano; do
    if command -v $editor >/dev/null; then
        export EDITOR=$editor
        break
    fi
done

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Setup Go proxy in China
export GOPROXY="https://goproxy.cn,direct"
export GOPRIVATE="dev.aminer.cn/*"

# Local proxy. Will be used in aliases like setproxy.
# To change it without being tracked by git,
# export the same variable in env/custom.sh to override.
export PROXY_ADDR="http://127.0.0.1:30000"
