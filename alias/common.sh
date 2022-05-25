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

# Short for helm
alias h="helm"

# Require confirmation before rm. This requires a newer version of rm.
# You need `brew install coreutils` on macOS. Linux is included by default.
alias rm="rm -I"