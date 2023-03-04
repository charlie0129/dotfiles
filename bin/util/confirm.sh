#!/usr/bin/env bash

yestoall=0
notoall=0
confirm() {
    if [[ $notoall -eq 1 ]]; then
        return 1
    fi
    while true; do
        echo "${1:-Continue}?"
        if [[ $yestoall -eq 1 ]]; then
            return 0
        fi
        echo -en "\t[\033[32;1my\033[0mes] [\033[32;1mY\033[0mes to all] [\033[32;1mn\033[0mo] [\033[32;1mN\033[0mo to all]: "
        read -r -n 1 REPLY
        case $REPLY in
        [y])
            printf "\033[2K\r"
            return 0
            ;;
        [n])
            printf "\033[2K\r\033[A\033[2K\r"
            return 1
            ;;
        [Y])
            printf "\033[2K\r"
            yestoall=1
            return 0
            ;;
        [N])
            printf "\033[2K\r\033[A\033[2K\r"
            notoall=1
            return 1
            ;;
        *) printf "\033[2K\r \033[31m %s \n\033[0m" "invalid input" ;;
        esac
    done
}