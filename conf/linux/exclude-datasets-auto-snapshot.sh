#!/usr/bin/env bash

EXCLUDE_PATTERNS=(
    "/var/log"
    "/var/lib/docker"
    "/var/lib/libvirt"
)

EXCLUDE_REGEXP=""

for i in "${EXCLUDE_PATTERNS[@]}"; do
    EXCLUDE_REGEXP+="$i"
    if [[ "${EXCLUDE_PATTERNS[@]:(-1)}" != "$i" ]]; then
        EXCLUDE_REGEXP+="|"
    fi
done

DATASETS=($(zfs list -o name -H | grep -E "$EXCLUDE_REGEXP"))

# if DATASETS length is 0, then exit error
if [[ -z $DATASETS ]]; then
  echo "No datasets found"
  exit 1
fi

echo "Auto snapshot on the following datasets will be disabled:"
for i in "${DATASETS[@]}"; do echo "  ${i}"; done

echo -n "Do you want to disable auto snapshot on these ${#DATASETS[@]} datasets? (y/n)"
while true; do
    read -r yn
    case $yn in
    [Yy]*)
        break
        ;;
    [Nn]*) exit 0 ;;
    *) echo "Please answer yes(Y/y) or no(N/n)." ;;
    esac
done

for i in "${DATASETS[@]}"; do
    sudo zfs set com.sun:auto-snapshot=false "${i}"
done
