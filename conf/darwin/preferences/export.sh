#!/bin/bash

set -euo pipefail

source "../../../bin/util/logger.sh"

mkdir -p exported
cd exported

domains=(
    # com.googlecode.iterm2 # Results in invalid XML
    com.apple.driver.AppleBluetoothMultitouch.trackpad
    com.apple.AppleMultitouchTrackpad
    com.macitbetter.betterzip
    com.coteditor.CotEditor
    com.movist.MovistPro
)

for domain in "${domains[@]}"; do
    info "Exporting defaults" domain "$domain"
    # Export to stdout to make sure plist is not binary.
    defaults export "$domain" - >"$domain.plist"
done

./sanitize.py


# Full export (deprecated)

# if ! macos-defaults -V >/dev/null 2>&1; then
#     echo "macos-defaults is not installed. Please install it first."
#     echo "Download it from here:"
#     echo "    https://github.com/dsully/macos-defaults/releases/latest"
#     exit 1
# fi

# if ! rust-parallel -V >/dev/null 2>&1; then
#     echo "rust-parallel is not installed. Please install it first."
#     echo "Download it from here:"
#     echo "    https://github.com/aaronriekenberg/rust-parallel/releases/latest"
#     echo "or install it via Homebrew:"
#     echo "    brew install rust-parallel"
#     exit 1
# fi

# mkdir -p exported
# cd exported

# defaults domains |
#     sed 's/, /|/g' |
#     tr '|' '\n' |
#     rust-parallel sh -c 'defaults export "$1" - >"$1.plist"' --
