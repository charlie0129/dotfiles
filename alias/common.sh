#!/usr/bin/env bash

# dir
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

# ls
if type lsd > /dev/null; then
    alias lsd='lsd --icon never'
    alias ls='lsd --group-directories-first'
fi
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'
alias lsa='ls -lah'

# htop with sudo as default
alias htop='sudo htop'

# Git
alias gcl1='git clone --recurse-submodules --shallow-submodules --depth=1'

# Quick update dotfiles
alias update-dotfiles='cd $DOTFILES_ROOT && git submodule update --remote && cd $OLDPWD'

# cloc with common non-relevant dirs excluded
alias cloc1="cloc --exclude-dir=node_modules,.idea,.mvn,.git --exclude-ext=.log,.lock,.tsbuildinfo"

# Zstandard related
alias tzst='tar --preserve-permissions --use-compress-program "zstd -T0" -cf'
alias untzst='tar --preserve-permissions --use-compress-program zstd -xf'

# Short for docker compose
alias comp="docker compose"

# Common mistakes
alias code.="code ."
alias code,="code ."
alias cd..="cd .."

# Setup local proxy
alias setproxy='export http_proxy=${PROXY_ADDR}; export https_proxy=${PROXY_ADDR}; export HTTP_PROXY=${PROXY_ADDR}; export HTTPS_PROXY=${PROXY_ADDR};'
alias unsetproxy="unset http_proxy; unset https_proxy; unset HTTP_PROXY; unset HTTPS_PROXY;"

# bbdown - Download Bilibili video
alias bbdown="bbdown --show-all --interactive --download-danmaku"

# Python aliases
alias py="python3"
alias py2="python2"
alias py3="python3"
alias py37="python3.7"
alias py38="python3.8"
alias py39="python3.9"
alias py310="python3.10"
alias py311="python3.11"
alias py312="python3.12"
alias py313="python3.13"
alias py314="python3.14"
alias py315="python3.15"
alias py316="python3.16"

# Alias conda to micromamba if conda is not found.
if ! type conda > /dev/null; then
    alias conda="micromamba"
fi

# Kubernetes
alias k9s="k9s --logoless"
alias k="kubectl"
alias kg="kubectl get"
alias kex="kubectl explain"
alias kpf="kubectl port-forward"
alias kns="kubectl node-shell"

alias zj="zellij"

alias tree='tree -a -I .git'

alias diff="diff --color=auto"

# iproute2 commands
# Why is this in common.sh? Does iproute2 linux-only?
# Because we have iproute2mac installed in this dotfile, so macOS can also use ip commands.
alias ip="ip --color=auto"
alias ip6="ip -6"
alias ipa="ip a"
alias ipl="ip l"
alias ipr="ip r"

# Disable / enable terminal line wrap
alias setwrap="tput smam"
alias setnowrap="tput rmam"
