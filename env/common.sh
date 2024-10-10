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

# ========== NIX ==========

if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

# ========== MISC ==========

export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# try nvim, vim, vi, nano in order
for editor in nvim vim vi nano; do
    if command -v $editor >/dev/null; then
        export EDITOR=$editor
        break
    fi
done

# Setup Go proxy in China
export GOPROXY="https://goproxy.cn,direct"
export GOPRIVATE="dev.aminer.cn/*"

# Local proxy. Will be used in aliases like setproxy.
# To change it without being tracked by git,
# export the same variable in env/custom.sh to override.
export PROXY_ADDR="http://127.0.0.1:30000"
