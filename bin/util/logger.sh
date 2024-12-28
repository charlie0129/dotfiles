#!/usr/bin/env bash

# Usage:
# Setting log levels:
#   `set_log_level <level>` (debug, info, warn, error)
# Simple logging:
#   `<debug|info|warn|error|fatal> <message>`
# Structured logging:
#   `<debug|info|warn|error|fatal> <message> <key1> <value1> <key2> <value2> ...`
# Testing log levels:
#   `is_<debug|info|warn|error>_level_enabled`

__LOG_LEVEL_DEBUG=0
__LOG_LEVEL_INFO=1
__LOG_LEVEL_WARN=2
__LOG_LEVEL_ERROR=3

__log_level=$__LOG_LEVEL_INFO

# Set log level: debug, info, warn, error
set_log_level() {
    case $1 in
    debug)
        __log_level=$__LOG_LEVEL_DEBUG
        ;;
    info)
        __log_level=$__LOG_LEVEL_INFO
        ;;
    warn)
        __log_level=$__LOG_LEVEL_WARN
        ;;
    error)
        __log_level=$__LOG_LEVEL_ERROR
        ;;
    *)
        echo "Invalid log level: $1. Valid log levels are: debug, info, warn, error"
        exit 1
        ;;
    esac
}

__is_level_enabled() {
    local level=$1
    [[ $level -ge $__log_level ]]
}

is_debug_level_enabled() {
    __is_level_enabled $__LOG_LEVEL_DEBUG
}

is_info_level_enabled() {
    __is_level_enabled $__LOG_LEVEL_INFO
}

is_warn_level_enabled() {
    __is_level_enabled $__LOG_LEVEL_WARN
}

is_error_level_enabled() {
    __is_level_enabled $__LOG_LEVEL_ERROR
}

if tty -s; then
    __in_terminal=1
fi

__color_reset="\033[0m"
__color_yellow="\033[33m"
__color_red="\033[31m"
__color_blue="\033[34m"

__datestr() {
    # RFC3339/ISO8601 format. To be able to run on macOS (BSD),
    # we cannot use %:z, so we have to manually add colon.
    # (GNU date) %Y-%m-%dT%H:%M:%S%:z -> 2021-01-16T23:09:44-05:00
    # (all dates) %Y-%m-%dT%H:%M:%S%z -> 2021-01-16T23:09:44-0500
    local time=$(date +%Y-%m-%dT%H:%M:%S%z)
    echo -n "${time:0:22}:${time:22:2}"
}

# Escape logfmt special characters
__logfmt_escape() {
    local value="$1"
    value="${value//\\/\\\\}"   # Escape backslashes
    value="${value//\"/\\\"}"   # Escape double quotes
    value="${value//$'\n'/\\n}" # Replace newline with \n
    echo -n "$value"
}

# Print log messages in logfmt format.
# Example: __logfmt_print <key1> <value1> <key2> <value2> ...
__logfmt_print() {
    local log_msg="time=\"$(__datestr)\""
    local key=""

    for param in "$@"; do
        if [[ -n "$key" ]]; then
            log_msg+=" $key=\"$(__logfmt_escape "$param")\""
            key=""
            continue
        fi
        key=$(__logfmt_escape "$param")
    done

    echo "$log_msg"
}

debug() {
    if ! is_debug_level_enabled; then
        return
    fi

    __logfmt_print level debug msg "$@"
}

info() {
    if ! is_info_level_enabled; then
        return
    fi

    if [[ -n $__in_terminal ]]; then
        echo -en "$__color_blue"
    fi
    __logfmt_print level info msg "$@"
    if [[ -n $__in_terminal ]]; then
        echo -en "$__color_reset"
    fi
}

warn() {
    if ! is_warn_level_enabled; then
        return
    fi

    if [[ -n $__in_terminal ]]; then
        echo -en "$__color_yellow"
    fi
    __logfmt_print level warn msg "$@"
    if [[ -n $__in_terminal ]]; then
        echo -en "$__color_reset"
    fi
}

error() {
    if ! is_error_level_enabled; then
        return
    fi

    if [[ -n $__in_terminal ]]; then
        echo -en "$__color_red"
    fi
    __logfmt_print level error msg "$@"
    if [[ -n $__in_terminal ]]; then
        echo -en "$__color_reset"
    fi
}

fatal() {
    if [[ -n $__in_terminal ]]; then
        echo -en "$__color_red"
    fi
    __logfmt_print level fatal msg "$@"
    if [[ -n $__in_terminal ]]; then
        echo -en "$__color_reset"
    fi

    exit 1
}
