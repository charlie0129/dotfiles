#!/usr/bin/env bash

# Git must be installed
if ! command -v git >/dev/null 2>&1; then
    echo "Git is not installed" 1>&2
    exit 1
fi

# Curl must be installed
if ! command -v curl >/dev/null 2>&1; then
    echo "curl is not installed" 1>&2
    exit 1
fi

# If .oh-my-zsh dir does not exist, install oh-my-zsh
if [ ! -d "${HOME}/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# If zsh-autosuggestions is not installed, install it
ZSH_AUTOSUGGESTIONS_DIR="${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
if [ ! -d "${ZSH_AUTOSUGGESTIONS_DIR}" ]; then
    git clone --depth=1 "https://github.com/zsh-users/zsh-autosuggestions.git" "${ZSH_AUTOSUGGESTIONS_DIR}"
fi

# If zsh-syntax-highlighting is not installed, install it
ZSH_SYNTAX_HIGHLIGHTING_DIR="${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
if [ ! -d "${ZSH_SYNTAX_HIGHLIGHTING_DIR}" ]; then
    git clone --depth=1 "https://github.com/zsh-users/zsh-syntax-highlighting.git" "${ZSH_SYNTAX_HIGHLIGHTING_DIR}"
fi

# If powerlevel10k is not installed, install it
POWERLEVEL10K_DIR="${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "${POWERLEVEL10K_DIR}" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${POWERLEVEL10K_DIR}"
fi

# If ~/.tmux dir does not exist, install oh-my-tmux
if [ ! -d "${HOME}/.tmux" ]; then
    git clone --depth=1 https://github.com/gpakosz/.tmux.git "${HOME}/.tmux"
    ln -s -f "${HOME}/.tmux/.tmux.conf" "${HOME}/.tmux.conf"
fi

# If ~/.vim_runtime dir does not exist, install vimrc
if [ ! -d "${HOME}/.vim_runtime" ]; then
    git clone --depth=1 https://github.com/amix/vimrc.git "${HOME}/.vim_runtime"
    sh "${HOME}/.vim_runtime/install_awesome_vimrc.sh"
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
        FORCE=-f
        shift
        ;;
    *)
        echo -e "Unknown argument: $1"
        echo ""
        exit 1
        ;;
    esac
done

function show_ln_fail_help() {
    echo -e "Linking failed!" 1>&2
    echo -e "If you want to overwrite them, use the -f flag." 1>&2
    exit 1
}

function fix_executable_permissions() {
    find bin -exec chmod +x {} \;
    chmod -x bin/custom/.gitkeep
}

# Link files
ln -s ${FORCE} "${REPO_ROOT}/.zshrc" "${HOME}/.zshrc" || show_ln_fail_help
ln -s ${FORCE} "${REPO_ROOT}/.zshenv" "${HOME}/.zshenv" || show_ln_fail_help
ln -s ${FORCE} "${REPO_ROOT}/.p10k.zsh" "${HOME}/.p10k.zsh" || show_ln_fail_help
ln -s ${FORCE} "${REPO_ROOT}/.Xmodmap" "${HOME}/.Xmodmap" || show_ln_fail_help
ln -s ${FORCE} "${REPO_ROOT}/.tmux.conf.local" "${HOME}/.tmux.conf.local" || show_ln_fail_help
ln -s ${FORCE} "${REPO_ROOT}/.conf.vim" "${HOME}/.vim_runtime/my_configs.vim" || show_ln_fail_help
ln -s ${FORCE} "${REPO_ROOT}/.ideavimrc" "${HOME}/.ideavimrc" || show_ln_fail_help

# Add +x permissions to all executables
fix_executable_permissions

# Install crontabs
# Install root crontab for darwin/linux
CRONFILE="${HOME}/dotfiles/cron/${OS}/root.conf"
if [ -f "${CRONFILE}" ] && [ "${OS}" = "darwin" ] || [ "${OS}" = "linux" ]; then
    sudo crontab "${CRONFILE}"
fi
# Install crontabs complete

# Do not track custom configs
CUSTOM_CONFIGS=(
    alias/custom.sh
    env/custom.sh
    custom-omz-plugins.sh
)
git update-index --skip-worktree "${CUSTOM_CONFIGS[@]}"

echo "Bootstrap complete!"
echo "Run reopen your terminal session or 'source ~/.zshrc' to reload the environment"
