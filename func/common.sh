#!/usr/bin/env bash

ksw() {
    local config_list=($(ksw_helper -l))
    ksw_helper
    local exitstatus=$?
    local chosenconfig="${config_list[$exitstatus]}"
    export "KUBECONFIG=$chosenconfig"
    echo "- export KUBECONFIG=$chosenconfig"
}

# Search for a package in nixpkgs. Features:
#   - searches for names only, instead of descriptions
#   - only match the beginning of the package name
#   - exclude xxxPackages sub packages
nix-search() {
    if [ -z "$1" ]; then
        echo "Usage: nix-search <package>"
        return 1
    fi

    nix search nixpkgs "$OS\\.$1" 2>/dev/null |
        grep "^*" |
        sed "s/.*$OS\\.//" |
        grep -v "Packages\." |
        sed 's/\x1B\[[0-9;]\{1,\}[A-Za-z]//g'
}

# Install a package from nixpkgs to the user profile.
nix-install() {
    if [ -z "$1" ]; then
        echo "Usage: nix-install <package>"
        return 1
    fi

    nix profile install nixpkgs#"$1"
}
