#!/usr/bin/env bash

# cd into where this script lives
SCRIPT_DIR="$(dirname "${BASH_SOURCE}")"
cd "${SCRIPT_DIR}" || exit 1

# Make sure SCRIPT_DIR is $HOME/dotfiles
if [ "${PWD}" != "${HOME}/dotfiles" ]; then
    echo "The whole dotfiles repo must be cloned to ${HOME}/dotfiles" 1>&2
    echo "Currently in ${PWD}" 1>&2
    exit 1
fi

FORCE=""

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



# link files
ln -s ${FORCE} "${PWD}/.zshrc" ~/.zshrc || show_ln_fail_help
ln -s ${FORCE} "${PWD}/.p10k.zsh" ~/.p10k.zsh || show_ln_fail_help