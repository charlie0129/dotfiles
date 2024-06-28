#!/bin/bash

cd "${BASH_SOURCE%/*}" || exit

source ../bin/util/logger.sh

mirror_user=https://vcs.bupt-narc.cn/charlie0129
mirror_remote_name=vcs

for repo in *; do
    if [ ! -d "$repo" ]; then
        continue
    fi
    cd "$repo"
    # Add mirror remote. Please make sure this repo exists on the mirror.
    if ! git remote get-url "$mirror_remote_name" >/dev/null 2>&1; then
        info "Adding remote $mirror_remote_name..."
        git remote add "$mirror_remote_name" "$mirror_user/$repo" >/dev/null
    fi
    info "Pushing $repo to $mirror_remote_name..."
    git push --force --all "$mirror_remote_name" >/dev/null
    cd ..
done
