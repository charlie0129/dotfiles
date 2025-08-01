#!/usr/bin/env bash

# git proxy
alias git_setproxy='git config --global http.proxy ${PROXY_ADDR}; git config --global https.proxy ${PROXY_ADDR};'
alias git_unsetproxy="git config --global --unset http.proxy; git config --global --unset https.proxy;"

# Get a shell inside Docker Desktop Linuxkit VM
alias nsenter="docker run -it --rm --privileged --pid=host justincormack/nsenter1"

# Load or Unload Zerotier background service
alias loadzerotier="sudo launchctl load /Library/LaunchDaemons/com.zerotier.one.plist"
alias unloadzerotier="sudo launchctl unload /Library/LaunchDaemons/com.zerotier.one.plist"

# Proxychain
alias pc="proxychains4"

# Transparent filesystem compression using afsctool
alias -g tcomp='applesauce compress --verify'
alias tcompi="applesauce info"

# common mistakes
alias open.="open ."
alias open,="open ."
