# DOTFILES_ROOT indicates the directory for this repo.
# Use this variable instead of hard-coded ~/dotfiles.
export DOTFILES_ROOT="$(dirname $(readlink ~/.zshrc))"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

# Source env definitions in this dotfiles repo
# Note that what sourced first will actually have lower priority.
# So custom env definitions have a priority like this: custom > os-specific > common
# Load common definitions
if [ -f "$DOTFILES_ROOT/env/common.sh" ]; then
    source "$DOTFILES_ROOT/env/common.sh"
fi
# OS specific definitions
if [ -f "$DOTFILES_ROOT/env/${OS}.sh" ]; then
    source "$DOTFILES_ROOT/env/${OS}.sh"
fi
# Custom definition always have higher priority
if [ -f "$DOTFILES_ROOT/env/custom.sh" ]; then
    source "$DOTFILES_ROOT/env/custom.sh"
fi
