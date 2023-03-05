#!/usr/bin/env bash

# AnVMSR
alias rdmsr='sudo $HOME/Documents/git/AnVMSR/Release-10.15/anvmsr readmsr'
alias wrmsr='sudo $HOME/Documents/git/AnVMSR/Release-10.15/anvmsr writemsr'

# Reset CrossOver bottle evaluation
alias rstbotteval='rm -f $HOME/Library/Application\ Support/CrossOver/Bottles/*/.eval'

# git proxy
alias git_setproxy="git config --global http.proxy http://127.0.0.1:1087; git config --global https.proxy http://127.0.0.1:1087;"
alias git_unsetproxy="git config --global --unset http.proxy; git config --global --unset https.proxy;"

# Get a shell inside Docker Desktop Linuxkit VM
alias nsenter="docker run -it --rm --privileged --pid=host justincormack/nsenter1 /bin/bash"

# Load or Unload Zerotier background service
alias loadzerotier="sudo launchctl load /Library/LaunchDaemons/com.zerotier.one.plist"
alias unloadzerotier="sudo launchctl unload /Library/LaunchDaemons/com.zerotier.one.plist"

# Proxychain
alias pc="proxychains4"

# Transparent filesystem compression using afsctool
alias -g tcomp="afsctool -c -J6 -T LZFSE"
alias tcompi="afsctool -v"
