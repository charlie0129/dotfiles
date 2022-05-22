#!/usr/bin/env bash

ROOT_DATASET="rpool/ROOT/ubuntu_uzcb39"

EXCLUDE_DATASETS=(
    "/var/log"
    "/var/lib/docker"
)

for i in "${EXCLUDE_DATASETS[@]}"; do
    sudo zfs set com.sun:auto-snapshot=false "${ROOT_DATASET}${i}"
done
