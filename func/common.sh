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

# Git Clone repository into a proper directory structure.
# For example, `git_clone https://github.com/charlie0129/dotfiles.git` or
# `git_clone git@github.com:charlie0129/dotfiles.git`
# will clone the repository into `~/src/github.com/charlie0129/dotfiles`.
git_clone() {
    if (( $# == 0 )); then
        echo "Usage: git_clone [--dry-run] [<git-clone-options>] [--] <repo>" >&2
        return 1
    fi

    local clone_dry_run=0 clone_arg
    local -a clone_args=()
    for clone_arg in "$@"; do
        if [[ "$clone_arg" == "--dry-run" ]]; then
            clone_dry_run=1
        else
            clone_args+=("$clone_arg")
        fi
    done

    if (( ${#clone_args[@]} == 0 )); then
        echo "Usage: git_clone [--dry-run] [<git-clone-options>] [--] <repo>" >&2
        return 1
    fi

    # The final argument is the URL to clone.
    local clone_url="${clone_args[-1]}"
    local clone_authority clone_host clone_location clone_repo_path

    case "$clone_url" in
        http://* | https://* | ssh://*)
            clone_location="${clone_url#*://}"
            clone_authority="${clone_location%%/*}"
            clone_repo_path="${clone_location#*/}"

            # Strip an optional user and port from the URL authority.
            clone_host="${clone_authority##*@}"
            if [[ "$clone_host" == \[*\]* ]]; then
                # IPv6 authorities use brackets, for example [::1]:2222.
                clone_host="${clone_host#\[}"
                clone_host="${clone_host%%\]*}"
            else
                clone_host="${clone_host%%:*}"
            fi
            ;;
        *:*)
            # SCP-like SSH syntax: [user@]host:path/to/repository.git. Git
            # only treats this as SSH when no slash appears before the colon.
            clone_authority="${clone_url%%:*}"
            if [[ "$clone_url" == *://* || "$clone_authority" == */* ]]; then
                echo "Error: repo must be an HTTP(S) or SSH URL" >&2
                return 1
            fi
            clone_host="${clone_authority##*@}"
            clone_repo_path="${clone_url#*:}"
            ;;
        *)
            echo "Error: repo must be an HTTP(S) or SSH URL" >&2
            echo >&2
            echo "Usage: git_clone [--dry-run] [<git-clone-options>] [--] <repo>" >&2
            return 1
            ;;
    esac

    # Turn the remote path into the directory Git creates by default.
    clone_repo_path="${clone_repo_path#/}"
    clone_repo_path="${clone_repo_path%/}"
    clone_repo_path="${clone_repo_path%.git}"

    if [[ -z "$clone_host" || "$clone_host" == "." || "$clone_host" == ".." ||
        -z "$clone_repo_path" ||
        "$clone_authority" == "$clone_location" ||
        "/$clone_repo_path/" == */./* || "/$clone_repo_path/" == */../* ]]; then
        echo "Error: could not determine a safe destination from '$clone_url'" >&2
        return 1
    fi

    local clone_rel_dir="$clone_host/$clone_repo_path"
    local clone_parent="$HOME/src/${clone_rel_dir%/*}"
    local clone_target="$HOME/src/$clone_rel_dir"

    echo "Will clone to ~/src/$clone_rel_dir" >&2
    if (( clone_dry_run )); then
        printf 'mkdir -p %q\n' "$clone_parent"
        printf 'cd %q\n' "$clone_parent"
        printf 'git clone'
        printf ' %q' "${clone_args[@]}"
        printf '\n'
        printf 'cd %q\n' "$clone_target"
        return 0
    fi

    mkdir -p "$clone_parent" || return 1
    cd "$clone_parent" || return 1

    # Example: $HOME/src/github.com/charlie0129/dotfiles
    git clone "${clone_args[@]}"
    local clone_status=$?
    if [ "$clone_status" -ne 0 ]; then
        echo "Error: git clone failed with status $clone_status" >&2
        return "$clone_status"
    fi

    cd "$clone_target" || return 1
}
