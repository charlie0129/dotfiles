#!/usr/bin/env bash

ksw() {
    local config_list=($(ksw_helper -l))
    ksw_helper
    local exitstatus=$?
    local chosenconfig="${config_list[$exitstatus]}"
    export "KUBECONFIG=$chosenconfig"
    local dir=$(dirname $chosenconfig)
    local filename=$(basename $chosenconfig)
    echo -e "- export KUBECONFIG=$dir/\033[32;1m$filename\033[0m"
}
