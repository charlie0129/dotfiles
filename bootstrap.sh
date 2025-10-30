#!/usr/bin/env bash

# cd into where this script lives
cd "$(dirname "${BASH_SOURCE}")" || exit 1

source bin/util/link_files.sh

export DOTFILES_ROOT="${PWD}"

FORCE=""
OVERWRITE_CUSTOM=""

# Colors
COLOR_RED="\033[31m"
COLOR_BLUE="\033[34m"
COLOR_GREEN="\033[32m"
COLOR_YELLOW="\033[33m"
COLOR_BOLD="\033[1m"
COLOR_RESET="\033[0m"

# Parse arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
    -f | --force)
        FORCE=y
        shift
        ;;
    --overwrite-custom)
        OVERWRITE_CUSTOM=y
        shift
        ;;
    *)
        echo -e "Unknown argument: $1"
        echo ""
        exit 1
        ;;
    esac
done

function fix_executable_permissions() {
    find bin -type f -not -name '*.md' -not -name '.gitkeep' -exec chmod +x {} \;
}

if ! command -v zsh >/dev/null 2>&1; then
    echo -e "${COLOR_RED}zsh is not installed. Please install it first.${COLOR_RESET}"
    exit 1
fi

# Link files
cd "$DOTFILES_ROOT" && link_files && cd "$DOTFILES_ROOT"

# Restore custom.sh's, but do not overwrite existing unless forced
for d in env func alias; do
    src="$d/.custom.sh"
    dst="$d/custom.sh"
    if [ -f "$dst" ] && [ -z "$OVERWRITE_CUSTOM" ]; then
        echo -e "${COLOR_YELLOW}Skipping existing $dst (use --overwrite-custom to overwrite)${COLOR_RESET}"
    else
        cp "$src" "$dst"
    fi
done

# Add +x permissions to all executables
bash bin/fix-permission

if [ "${SHELL}" != "$(which zsh)" ]; then
    echo -e "Your default shell is not zsh. Use '${COLOR_BOLD}chsh -s $(which zsh)${COLOR_RESET}' to change it."
fi

echo -e "Bootstrap complete! ${COLOR_BOLD}Please DO check the output above for any errors.${COLOR_RESET}"
echo -e "Log out and back in for the changes to take effect."
