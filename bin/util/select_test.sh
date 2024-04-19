#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE}")/select.sh"

options=({1..12})

select_option "${options[@]}"
result="${options[$?]}"

echo "You chose: $result"
