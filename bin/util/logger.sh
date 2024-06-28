#!/usr/bin/env bash

color_reset="\033[0m"
color_yellow="\033[33m"
color_red="\033[31m"
color_blue="\033[34m"

datestr() {
    date +'%Y-%m-%d %H:%M:%S'
}

info() {
    echo -e "$(datestr) ${color_blue}[INFO]${color_reset} $*"
}

warn() {
    echo -e "$(datestr) ${color_yellow}[WARN]${color_reset} $*"
}

error() {
    echo -e "$(datestr) ${color_red}[ERRO]${color_reset} $*"
}

fatal() {
    echo -e "$(datestr) ${color_red}[FATA]${color_reset} $*"
    exit 1
}
