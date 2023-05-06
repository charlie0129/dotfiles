#!/usr/bin/env bash

info() {
    echo -e "$(date +'%Y-%m-%d %H:%M:%S') \033[34m[INFO]\033[0m $*"
}

warn() {
    echo -e "$(date +'%Y-%m-%d %H:%M:%S') \033[33m[WARN]\033[0m $*"
}

error() {
    echo -e "$(date +'%Y-%m-%d %H:%M:%S') \033[31m[ERRO]\033[0m $*"
}

