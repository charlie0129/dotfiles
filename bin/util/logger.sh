#!/usr/bin/env bash

# Usage: see logger_test.sh for examples.
#
# Setting log levels:
#   `set_log_level <level>` (debug, info, warn, error)
# Setting logger output:
#   `set_logger_output <stdout|stderr|1|2|file>`
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

__output_has_tty="" # This decides if we should use tty colors or not.

__check_tty() {
    if [ -t 1 ]; then
        __output_has_tty=1
    else
        __output_has_tty=""
    fi
}

__logger_output="/dev/stderr"

set_logger_output() {
    case $1 in
    stdout | stderr)
        __logger_output="/dev/$1"
        __check_tty # We need to check again.
        ;;
    1 | 2)
        __logger_output="/dev/fd/$1"
        __check_tty # We need to check again.
        ;;
    *)
        if echo -n >>"$1" 2>/dev/null; then
            __logger_output="$1"
            __output_has_tty="" # File output does not support tty colors.
        else
            echo "Output file $1 is not writable."
            exit 1
        fi
    esac
}

# Default to stderr.
set_logger_output stderr

__color_reset="\033[0m"
__color_yellow="\033[33m"
__color_red="\033[31m"
__color_blue="\033[34m"

__print_color_reset() {
    if [[ -n $__output_has_tty ]]; then
        echo -en "$__color_reset" >>"$__logger_output"
    fi
}

__print_color_yellow() {
    if [[ -n $__output_has_tty ]]; then
        echo -en "$__color_yellow" >>"$__logger_output"
    fi
}

__print_color_red() {
    if [[ -n $__output_has_tty ]]; then
        echo -en "$__color_red" >>"$__logger_output"
    fi
}

__print_color_blue() {
    if [[ -n $__output_has_tty ]]; then
        echo -en "$__color_blue" >>"$__logger_output"
    fi
}

__datestr() {
    # RFC3339/ISO8601 format. To be able to run on macOS (BSD),
    # we cannot use %:z, so we have to manually add colon.
    # (GNU date) %Y-%m-%dT%H:%M:%S%:z -> 2021-01-16T23:09:44-05:00
    # (all dates) %Y-%m-%dT%H:%M:%S%z -> 2021-01-16T23:09:44-0500
    local time=$(date +%Y-%m-%dT%H:%M:%S%z)
    echo -n "${time:0:22}:${time:22:2}"
}

__need_quotes() {
    local value="$1"
    # If any of the following characters are present, we need to quote the value.
    # [:space:] [:cntrl:] " =
    [[ "$value" =~ [[:space:]] || "$value" =~ [[:cntrl:]] || "$value" =~ [=\"] ]]
}

# Escape logfmt special characters
__logfmt_escape() {
    local value="$1"
    value="${value//\\/\\\\}"   # Escape backslashes
    value="${value//\"/\\\"}"   # Escape double quotes
    value="${value//$'\n'/\\n}" # Replace newline with \n
    value="${value//$'\r'/\\r}" # Replace carriage return with \r
    value="${value//$'\t'/\\t}" # Replace tab with \t
    value="${value//$'\v'/\\v}" # Replace vertical tab with \v
    value="${value//$'\f'/\\f}" # Replace form feed with \f
    value="${value//$'\b'/\\b}" # Replace backspace with \b
    value="${value//$'\a'/\\a}" # Replace bell with \a
    value="${value//$'\e'/\\e}" # Replace escape with \e
    echo -n "$value" | LC_CTYPE=C tr -dc '[:print:]' # Remove all other control characters
}

__logfmt_kv_format() {
    local value="$1"
    if __need_quotes "$value"; then
        echo -n "\"$(__logfmt_escape "$value")\""
    else
        echo -n "$value"
    fi
}

# Print log messages in logfmt format.
# Example: logfmt_print <key1> <value1> <key2> <value2> ...
logfmt_print() {
    local log_msg=""
    local key=""

    for param in "$@"; do
        if [[ -z "$param" ]]; then
            continue
        fi
        if [[ -n "$key" ]]; then
            if [[ -n "$log_msg" ]]; then
                log_msg+=" "
            fi
            log_msg+="$(__logfmt_kv_format "$key")=$(__logfmt_kv_format "$param")"
            key=""
            continue
        fi
        key="$param"
    done

    echo "$log_msg" >>"$__logger_output"
}

logfmt_print_with_timestamp() {
    logfmt_print time "$(__datestr)" "$@"
}

debug() {
    if ! is_debug_level_enabled; then
        return
    fi

    logfmt_print_with_timestamp level debug msg "$@"
}

info() {
    if ! is_info_level_enabled; then
        return
    fi

    __print_color_blue
    logfmt_print_with_timestamp level info msg "$@"
    __print_color_reset
}

warn() {
    if ! is_warn_level_enabled; then
        return
    fi

    __print_color_yellow
    logfmt_print_with_timestamp level warn msg "$@"
    __print_color_reset
}

error() {
    if ! is_error_level_enabled; then
        return
    fi

    __print_color_red
    logfmt_print_with_timestamp level error msg "$@"
    __print_color_reset
}

fatal() {
    __print_color_red
    logfmt_print_with_timestamp level fatal msg "$@"
    __print_color_reset

    exit 1
}
