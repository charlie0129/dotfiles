#!/usr/bin/env bash

# git proxy
alias git_setproxy='git config --global http.proxy ${PROXY_ADDR}; git config --global https.proxy ${PROXY_ADDR};'
alias git_unsetproxy="git config --global --unset http.proxy; git config --global --unset https.proxy;"

# Get a shell inside Docker Desktop Linuxkit VM
alias nsenter="docker run -it --rm --privileged --pid=host justincormack/nsenter1 /bin/bash"

# Load or Unload Zerotier background service
alias loadzerotier="sudo launchctl load /Library/LaunchDaemons/com.zerotier.one.plist"
alias unloadzerotier="sudo launchctl unload /Library/LaunchDaemons/com.zerotier.one.plist"

# Proxychain
alias pc="proxychains4"

# Transparent filesystem compression using afsctool
alias -g tcomp='afsctool -c -J$(sysctl -n hw.physicalcpu) -T LZFSE'
alias tcompi="afsctool -v"

# asitop: monitor Apple Silicon macos
alias asitop="sudo asitop --color 7"