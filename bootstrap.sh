#!/usr/bin/env bash

# cd into where this script lives
cd "$(dirname "${BASH_SOURCE}")" || exit 1

export DOTFILES_ROOT="${PWD}"

FORCE=""

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
    *)
        echo -e "Unknown argument: $1"
        echo ""
        exit 1
        ;;
    esac
done

function link_files() {
    # Read `.pathmapping file' into array line by line
    IFS=$'\n' read -d "" -ra file_data <".pathmapping"

    for element in "${file_data[@]}"; do
        # Ignore comments
        if [[ $element == \#* ]]; then
            continue
        fi

        # Split string by colon
        IFS=':' read -ra splitted <<<"$element"
        # Make sure splitted has 2 elements
        if [ ${#splitted[@]} -ne 2 ]; then
            echo "Invalid line: $element"
            continue
        fi

        # Get source and destination
        src="$PWD/$(eval echo ${splitted[0]})"
        dst="$(eval echo ${splitted[1]})"

        printf "Linking '%s' to '%s'" "$src" "$dst"
        # If dst already exists. -e does not cover all cases (when symlink is not valid)
        # so we also check if it's a symlink
        if [[ -e "$dst" || -L "$dst" ]]; then
            # If it's a symlink
            if [ -L "$dst" ]; then
                # If it's a symlink to src
                if [ "$(readlink "$dst")" == "$src" ]; then
                    printf "${COLOR_GREEN}%s${COLOR_RESET}\n" " - already linked"
                    continue
                fi
            fi

            # If it's not a symlink, or it's a symlink to something else
            if [ "$FORCE" == "y" ]; then
                printf "${COLOR_YELLOW}%s${COLOR_RESET}\n" " - overwriting"
                rm -rf "$dst"
            else
                printf "${COLOR_YELLOW}%s${COLOR_RESET}\n" " - skipped (file already exists, use -f to overwrite)"
                continue
            fi
        fi
        printf "..."
        # Make sure parent directory exists
        mkdir -p "$(dirname "$dst")"
        # Create symlink
        ln -s "$src" "$dst"
        printf "\n"
    done
}

function fix_executable_permissions() {
    find bin -type f -not -name '*.md' -not -name '.gitkeep' -exec chmod +x {} \;
}

if ! command -v zsh >/dev/null 2>&1; then
    echo -e "${COLOR_RED}zsh is not installed. Please install it first.${COLOR_RESET}"
    exit 1
fi

# Link dependencies
cd dep && link_files && cd "$DOTFILES_ROOT"
# Link files
cd "$DOTFILES_ROOT" && link_files && cd "$DOTFILES_ROOT"

# Add +x permissions to all executables
fix_executable_permissions

# If git is installed, skip tracking custom configs
CUSTOM_CONFIGS=(
    alias/custom.sh
    env/custom.sh
    func/custom.sh
    custom-omz-plugins.sh
)
if command -v git >/dev/null 2>&1; then
    git update-index --skip-worktree "${CUSTOM_CONFIGS[@]}"
    # To revert: git update-index --no-skip-worktree "${CUSTOM_CONFIGS[@]}"
fi

if [ "${SHELL}" != "$(which zsh)" ]; then
    echo -e "Your default shell is not zsh. Use '${COLOR_BOLD}chsh -s $(which zsh)${COLOR_RESET}' to change it."
fi

echo -e "Bootstrap complete! ${COLOR_BOLD}Please DO check the output above for any errors.${COLOR_RESET}"
echo -e "Run '${COLOR_BOLD}source ~/.zshrc${COLOR_RESET}' for the changes to take effect."
