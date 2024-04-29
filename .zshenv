# DOTFILES_ROOT indicates the directory for this repo.
# Use this variable instead of hard-coded ~/dotfiles.
export DOTFILES_ROOT="$(dirname $(readlink ~/.zshrc))"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

# Source helper. This is used to load env/alias/func definitions in this repo in the correct order.
__source() {
    if [ -z "$1" ]; then
        echo "Usage: __source <env|alias|func>"
        return 1
    fi
    # check for existence of the directory
    if [ ! -d "$DOTFILES_ROOT/$1" ]; then
        echo "Directory $DOTFILES_ROOT/$1 does not exist."
        return 1
    fi
    # Note that what sourced first will actually have lower priority.
    # So custom env definitions have a priority like this: custom > os-specific > common
    local types=(
        common
        $OS
        custom # Custom definition always have higher priority
    )
    for type in "${types[@]}"; do
        if [ -f "$DOTFILES_ROOT/$1/$type.sh" ]; then
            source "$DOTFILES_ROOT/$1/$type.sh"
        fi
    done
}

# Load env definitions
__source env
