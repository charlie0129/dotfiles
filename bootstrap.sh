#!/usr/bin/env bash

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

# cd into where this script lives
cd "$(dirname "${BASH_SOURCE}")" || exit 1

# link files
ln -s ${FORCE} "${PWD}/.zshrc" ~/.zshrc || show_ln_fail_help
ln -s ${FORCE} "${PWD}/.p10k.zsh" ~/.p10k.zsh || show_ln_fail_help