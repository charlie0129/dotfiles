#!/usr/bin/env bash

# Make sure bash version is at least 4.0
BASH_VERSION_MAJOR=$(echo "${BASH_VERSION}" | cut -d. -f1)
if [ "${BASH_VERSION_MAJOR}" -lt 4 ]; then
    echo "Bash version must be at least 4.0, but you are running ${BASH_VERSION}." 1>&2
    echo "This error typically occurs on macOS. You can install a newer bash using Homebrew." 1>&2
    exit 1
fi

# cd into where this script lives
SCRIPT_DIR="$(dirname "${BASH_SOURCE}")"
cd "${SCRIPT_DIR}" || exit 1

REPO_ROOT="${PWD}"

# Make sure REPO_ROOT is ${HOME}/dotfiles
if [ "${REPO_ROOT}" != "${HOME}/dotfiles" ]; then
    echo "The whole dotfiles repo must be cloned to ${HOME}/dotfiles" 1>&2
    echo "Currently in ${REPO_ROOT}" 1>&2
    exit 1
fi

FORCE=""
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

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
                    printf "%s\n" " - already linked"
                    continue
                fi
            fi

            # If it's not a symlink, or it's a symlink to something else
            if [ "$FORCE" == "y" ]; then
                printf "%s" " - overwriting"
                rm -rf "$dst"
            else
                printf "%s\n" " - skipped (file already exists, use -f to overwrite)"
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

# Link dependencies
cd dep && link_files && cd "$OLDPWD"
# Link files
cd $REPO_ROOT && link_files && cd "$OLDPWD"

# Add +x permissions to all executables
fix_executable_permissions

# Install crontabs
if command -v cron >/dev/null 2>&1; then
    # Install *root* crontab for darwin/linux
    CRONFILE="${HOME}/dotfiles/cron/${OS}/root.conf"
    if [ -f "${CRONFILE}" ] && [ "${OS}" = "darwin" ] || [ "${OS}" = "linux" ]; then
        if [ "$EUID" -ne 0 ]; then
            sudo crontab "${CRONFILE}"
        else
            crontab "${CRONFILE}"
        fi
    fi
fi

# Do not track custom configs
CUSTOM_CONFIGS=(
    alias/custom.sh
    env/custom.sh
    custom-omz-plugins.sh
)
# If git is installed, skip tracking custom configs
if command -v git >/dev/null 2>&1; then
    git update-index --skip-worktree "${CUSTOM_CONFIGS[@]}"
fi

if [ "${SHELL}" != "/bin/zsh" ]; then
    echo "Your default shell is not zsh. Use 'chsh -s /bin/zsh' to change it."
fi

echo "Bootstrap complete!"
echo "Run 'source ~/.zshrc' for the changes to take effect."
