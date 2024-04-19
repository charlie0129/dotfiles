#!/usr/bin/env bash

# htop with sudo as default
alias htop='sudo htop'

# Shallow git clone
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

alias k9s="k9s --logoless"
alias k="kubectl"
alias kns="kubectl node-shell"
