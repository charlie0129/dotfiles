#!/usr/bin/env bash

# dir
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

# ls
if type lsd >/dev/null 2>&1; then
    alias lsd='lsd --icon never --date "+%Y-%m-%d %H:%M:%S"'
    alias ls='lsd --group-directories-first'
else
    if [[ "$OS" == "darwin" ]]; then
        alias ls='ls -G -D "%Y-%m-%d %H:%M:%S"'
    elif [[ "$OS" == "linux" ]]; then
        alias ls='ls --color=auto --time-style="+%Y-%m-%d %H:%M:%S"'
    fi
fi
alias l='ls -lahF'
alias ll='ls -lhF'
alias la='ls -lAhF'
alias lsa='ls -lahF'

# Git
alias gcl1='git clone --recurse-submodules --shallow-submodules --depth=1'

# cloc with common non-relevant dirs excluded
alias cloc1="cloc --exclude-dir=node_modules,.idea,.mvn,.git --exclude-ext=.log,.lock,.tsbuildinfo"

# Zstandard related
alias tzst='tar --preserve-permissions --use-compress-program "zstd -T0" -cf'
alias untzst='tar --preserve-permissions --use-compress-program unzstd -xf'

# Short for docker compose
if type docker-compose > /dev/null 2>&1; then
    alias comp="docker-compose"
else
    alias comp="docker compose"
fi

# Common mistakes
alias code.="code ."
alias code,="code ."
alias cd..="cd .."

# Setup local proxy
alias setproxy='export http_proxy=${PROXY_ADDR} https_proxy=${PROXY_ADDR} HTTP_PROXY=${PROXY_ADDR} HTTPS_PROXY=${PROXY_ADDR}'
alias unsetproxy="unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY"

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
alias k="kubectl"
alias kg="kubectl get"
alias kex="kubectl explain"
alias kpf="kubectl port-forward"
alias kns="kubectl node-shell"
alias kdf="kubectl delete -f"
alias kaf="kubectl apply -f"

alias zj="zellij"

alias tree='tree -a -I .git'

alias diff="diff --color=auto"

# iproute2 commands
# Why is this in common.sh? Is iproute2 linux-only?
# Because we have iproute2mac installed in this dotfile, so macOS can also use ip commands.
alias ip="ip --color=auto"
alias ip6="ip -6"
alias ipa="ip a"
alias ipl="ip l"
alias ipr="ip r"
alias ip6a="ip6 a"
alias ip6r="ip6 r"

# Disable / enable terminal line wrap
alias setwrap="tput smam"
alias setnowrap="tput rmam"

# Minimal config has no git aliases, so we add some here.
# They are from ohmyzsh git plugin.
alias ga='git add'
alias gaa='git add --all'
alias gapa='git add --patch'
alias gau='git add --update'
alias gav='git add --verbose'
alias gap='git apply'
alias gapt='git apply --3way'

alias gb='git branch'
alias gba='git branch --all'
alias gbd='git branch --delete'
alias gbl='git blame -b -w'
alias gbnm='git branch --no-merged'
alias gbr='git branch --remote'
alias gbs='git bisect'
alias gbsb='git bisect bad'
alias gbsg='git bisect good'
alias gbsr='git bisect reset'
alias gbss='git bisect start'

alias gc='git commit --verbose'
alias gc!='git commit --verbose --amend'
alias gcn!='git commit --verbose --no-edit --amend'
alias gca='git commit --verbose --all'
alias gca!='git commit --verbose --all --amend'
alias gcan!='git commit --verbose --all --no-edit --amend'
alias gcans!='git commit --verbose --all --signoff --no-edit --amend'
alias gcam='git commit --all --message'
alias gcsm='git commit --signoff --message'
alias gcas='git commit --all --signoff'
alias gcasm='git commit --all --signoff --message'
alias gcb='git checkout -b'
alias gcf='git config --list'

alias gcl='git clone --recurse-submodules'
alias gclean='git clean --interactive -d'
alias gpristine='git reset --hard && git clean --force -dfx'
alias gcmsg='git commit --message'
alias gco='git checkout'
alias gcor='git checkout --recurse-submodules'
alias gcount='git shortlog --summary --numbered'
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
alias gcs='git commit --gpg-sign'
alias gcss='git commit --gpg-sign --signoff'
alias gcssm='git commit --gpg-sign --signoff --message'

alias gd='git diff'
alias gdca='git diff --cached'
alias gdcw='git diff --cached --word-diff'
alias gds='git diff --staged'
alias gdt='git diff-tree --no-commit-id --name-only -r'
alias gdup='git diff @{upstream}'
alias gdw='git diff --word-diff'

alias gf='git fetch'
alias gfa='git fetch --all --prune --jobs=10'
alias gfo='git fetch origin'
alias gfg='git ls-files | grep'

alias gg='git gui citool'
alias gga='git gui citool --amend'

alias ghh='git help'

alias gignore='git update-index --assume-unchanged'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'

alias gl='git pull'
alias glg='git log --stat'
alias glgp='git log --stat --patch'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
alias glo='git log --oneline --decorate'
alias glol="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'"
alias glols="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --stat"
alias glod="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'"
alias glods="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short"
alias glola="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --all"
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias glp="_git_log_prettily"

alias gm='git merge'
alias gmtl='git mergetool --no-prompt'
alias gmtlvim='git mergetool --no-prompt --tool=vimdiff'
alias gma='git merge --abort'
alias gms="git merge --squash"

alias gp='git push'
alias gpd='git push --dry-run'
alias gpf='git push --force-with-lease --force-if-includes'
alias gpf!='git push --force'
alias gpoat='git push origin --all && git push origin --tags'
alias gpod='git push origin --delete'
alias gpr='git pull --rebase'
alias gpu='git push upstream'
alias gpv='git push --verbose'

alias gr='git remote'
alias gra='git remote add'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase --interactive'
alias grbo='git rebase --onto'
alias grbs='git rebase --skip'
alias grev='git revert'
alias grh='git reset'
alias grhh='git reset --hard'
alias grm='git rm'
alias grmc='git rm --cached'
alias grmv='git remote rename'
alias grrm='git remote remove'
alias grs='git restore'
alias grset='git remote set-url'
alias grss='git restore --source'
alias grst='git restore --staged'
alias gru='git reset --'
alias grup='git remote update'
alias grv='git remote --verbose'

alias gsb='git status --short --branch'
alias gsd='git svn dcommit'
alias gsh='git show'
alias gsi='git submodule init'
alias gsps='git show --pretty=short --show-signature'
alias gsr='git svn rebase'
alias gss='git status --short'
alias gst='git status'

alias gsta='git stash push'
alias gstaa='git stash apply'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show --text'
alias gstu='gsta --include-untracked'
alias gstall='git stash --all'
alias gsu='git submodule update'
alias gsw='git switch'
alias gswc='git switch --create'

alias gts='git tag --sign'
alias gtv='git tag | sort -V'

alias gunignore='git update-index --no-assume-unchanged'
alias gunwip='git log --max-count=1 | grep -q -c "\--wip--" && git reset HEAD~1'
alias gup='git pull --rebase'
alias gupv='git pull --rebase --verbose'
alias gupa='git pull --rebase --autostash'
alias gupav='git pull --rebase --autostash --verbose'

alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"'

alias gwt='git worktree'
alias gwta='git worktree add'
alias gwtls='git worktree list'
alias gwtmv='git worktree move'
alias gwtrm='git worktree remove'

alias gam='git am'
alias gamc='git am --continue'
alias gams='git am --skip'
alias gama='git am --abort'
alias gamscp='git am --show-current-patch'
