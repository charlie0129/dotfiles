#!/usr/bin/env bash

# htop with sudo as default
alias htop='sudo htop'

# Shallow git clone
alias gcl1='git clone --depth=1'

# cloc with common non-relevant dirs excluded
alias cloc1="cloc --exclude-dir=node_modules,.idea,.mvn,.git --exclude-ext=.log,.lock,.tsbuildinfo"

# Short for docker-compose
alias comp="docker-compose"

# Short for kubectl
alias k="kubectl"
alias kgp="kubectl get pods"
alias kgd="kubectl get deployments"

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

