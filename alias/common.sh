#!/usr/bin/env bash

# htop with sudo as default
alias htop='sudo htop'

# Shallow git clone
alias gcl1='git clone --depth=1'

# Quick update dotfiles
alias update-dotfiles='git -C ${HOME}/dotfiles pull'

# cloc with common non-relevant dirs excluded
alias cloc1="cloc --exclude-dir=node_modules,.idea,.mvn,.git --exclude-ext=.log,.lock,.tsbuildinfo"

# Zstandard related
alias tzst="tar --preserve-permissions --use-compress-program zstd -cf"
alias untzst="tar --preserve-permissions --use-compress-program zstd -xf"

# Short for docker-compose
alias comp="docker-compose"

# Short for kubectl
alias k="kubectl"
alias kgp="kubectl get pods"
alias kgd="kubectl get deployments"
alias kgno"kubectl get nodes"

# short for vela
alias v="vela"
alias va="vela addon"
alias vae="vela addon enable"
alias vad="vela addon disable"
alias val="vela addon list"
alias vap="vela addon package"
alias vd="vela def"
alias vdl="vela def list"

# Short for helm
alias h="helm"

# Common mistakes
alias code.="code ."