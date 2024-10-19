#!/usr/bin/env bash

# Kubernetes SWitcher
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

# Z interactive: interactive directory jump
zi() {
    local dir
    dir=$(z -l | awk '{print $2}' | fzf --query="$LBUFFER" --tac --no-sort --select-1 --exit-0) &&
        cd "$dir" || return
}

# Find Path
fp() {
    local loc=$(echo $PATH | sed -e $'s/:/\\\n/g' | eval "fzf ${FZF_DEFAULT_OPTS} --header='[find:path]'")

    if [[ -d $loc ]]; then
        echo "$(rg --files $loc | rev | cut -d"/" -f1 | rev)" | eval "fzf ${FZF_DEFAULT_OPTS} --header='[find:exe] => ${loc}' >/dev/null"
        fp
    fi
}

# Kill Process
kp() {
    local pid=$(ps -ef | sed 1d | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[kill:process]'" | awk '{print $2}')

    if [ "x$pid" != "x" ]; then
        echo $pid | xargs kill -${1:-9}
        kp
    fi
}

# Kill Server
ks() {
    local pid=$(lsof -Pwni | sed 1d | grep -e LISTEN -e '\*:' | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[kill:tcp]'" | awk '{print $2}')

    if [ "x$pid" != "x" ]; then
        echo $pid | xargs kill -${1:-9}
        ks
    fi
}
