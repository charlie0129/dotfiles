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

# mnemonic: [F]ind [P]ath
fp() {
    local loc=$(echo $PATH | sed -e $'s/:/\\\n/g' | eval "fzf ${FZF_DEFAULT_OPTS} --header='[find:path]'")

    if [[ -d $loc ]]; then
        echo "$(rg --files $loc | rev | cut -d"/" -f1 | rev)" | eval "fzf ${FZF_DEFAULT_OPTS} --header='[find:exe] => ${loc}' >/dev/null"
        fp
    fi
}

# mnemonic: [K]ill [P]rocess
kp() {
    local pid=$(ps -ef | sed 1d | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[kill:process]'" | awk '{print $2}')

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
        kp
    fi
}

# mnemonic: [K]ill [S]erver
ks() {
    local pid=$(lsof -Pwni | sed 1d | grep -e LISTEN -e '\*:' | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[kill:tcp]'" | awk '{print $2}')

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
        ks
    fi
}
