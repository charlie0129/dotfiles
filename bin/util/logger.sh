#!/usr/bin/env bash

# logger.sh - A structured logging (logfmt) utility for bash scripts.
#
# By default, it logs to stderr. If the output is a terminal (tty),
# it make output more human-readable and uses colors to highlight log levels.
# This format is NOT compatible with logfmt parsers. If the output is
# not a terminal, it uses logfmt format, which is compatible with
# logfmt parsers and can be used for structured logging.
#
# Usage: see logger_test.sh for examples.
#
# Setting log levels:
#   `set_log_level <level>` (debug, info, warn, error)
#
# Setting logger output file:
#   `set_logger_output <stdout|stderr|1|2|file>`
#
# Simple logging:
#   `<debug|info|warn|error|fatal> <message>`
#
# Structured logging:
#   `<debug|info|warn|error|fatal> <message> <key1> <value1> <key2> <value2> ...`
#
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
        ;;
    esac
}

# Default to stderr.
set_logger_output stderr

__color_reset="\033[0m"
__color_bold="\033[1m"
__color_bold_yellow="\033[1;33m"
__color_bold_red="\033[1;31m"
__color_bold_blue="\033[1;34m"
__color_yellow="\033[33m"
__color_red="\033[31m"
__color_blue="\033[34m"
__color_faint="\033[2m"

__print_color_reset() {
    if [[ -n $__output_has_tty ]]; then
        echo -en "$__color_reset"
    fi
}

__print_color_bold() {
    if [[ -n $__output_has_tty ]]; then
        echo -en "$__color_bold"
    fi
}

__print_color_yellow() {
    if [[ -n $__output_has_tty ]]; then
        echo -en "$__color_yellow"
    fi
}

__print_color_red() {
    if [[ -n $__output_has_tty ]]; then
        echo -en "$__color_red"
    fi
}

__print_color_blue() {
    if [[ -n $__output_has_tty ]]; then
        echo -en "$__color_blue"
    fi
}

__print_color_bold_yellow() {
    if [[ -n $__output_has_tty ]]; then
        echo -en "$__color_bold_yellow"
    fi
}

__print_color_bold_red() {
    if [[ -n $__output_has_tty ]]; then
        echo -en "$__color_bold_red"
    fi
}

__print_color_bold_blue() {
    if [[ -n $__output_has_tty ]]; then
        echo -en "$__color_bold_blue"
    fi
}

__print_color_faint() {
    if [[ -n $__output_has_tty ]]; then
        echo -en "$__color_faint"
    fi
}

__datestr() {
    if [[ -n $__output_has_tty ]]; then
        # Use short format to make it more human-readable.
        # We cannot use %3N for milliseconds, so we use %N and then slice it.
        local time=$(date +"%H:%M:%S.%N")
        echo -n "${time:0:12}"
        return
    fi
    # RFC3339/ISO8601 format. To be able to run on macOS (BSD),
    # we cannot use %:z, so we have to manually add colon.
    # (GNU date) %Y-%m-%dT%H:%M:%S%:z -> 2025-06-19T16:29:10.158533118+08:00
    # (all dates) %Y-%m-%dT%H:%M:%S%z -> 2025-06-19T16:29:10.158533118+0800
    # We cannot use %3N for milliseconds too, so we use %N and then slice it.
    local time=$(date +%Y-%m-%dT%H:%M:%S.%N%z)
    echo -n "${time:0:23}${time:29:3}:${time:32:2}"
}

__faint_datestr() {
    echo -n "$(__print_color_faint)$(__datestr)$(__print_color_reset)"
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
    value="${value//\\/\\\\}"                        # Escape backslashes
    value="${value//\"/\\\"}"                        # Escape double quotes
    value="${value//$'\n'/\\n}"                      # Replace newline with \n
    value="${value//$'\r'/\\r}"                      # Replace carriage return with \r
    value="${value//$'\t'/\\t}"                      # Replace tab with \t
    value="${value//$'\v'/\\v}"                      # Replace vertical tab with \v
    value="${value//$'\f'/\\f}"                      # Replace form feed with \f
    value="${value//$'\b'/\\b}"                      # Replace backspace with \b
    value="${value//$'\a'/\\a}"                      # Replace bell with \a
    value="${value//$'\e'/\\e}"                      # Replace escape with \e
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

__logfmt_print_kv() {
    local key="$1"
    local value="$2"

    if [[ -z "$key" || -z "$value" ]]; then
        return
    fi

    # Print key
    echo -n "$(__print_color_faint)"
    echo -n "$(__logfmt_kv_format "$key")"
    # =
    echo -n "="
    echo -n "$(__print_color_reset)"
    # Print value
    echo -n "$(__logfmt_kv_format "$value")"
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
            log_msg+="$(__logfmt_print_kv "$key" "$param")"
            key=""
            continue
        fi
        key="$param"
    done

    # key should be empty now, if not, we have an odd number of parameters.
    if [[ -n "$key" ]]; then
        if [[ -n "$log_msg" ]]; then
            log_msg+=" "
        fi
        log_msg+="$(__logfmt_print_kv "$key" "!INVALID_KEY")"
        key=""
    fi

    echo "$log_msg" >>"$__logger_output"
}

logfmt_print_with_timestamp() {
    logfmt_print time "$(__datestr)" "$@"
}

debug() {
    if ! is_debug_level_enabled; then
        return
    fi

    if [[ -n $__output_has_tty ]]; then
        echo -n "$(__faint_datestr) " >>"$__logger_output"
        echo -n "$(__print_color_bold)" >>"$__logger_output"
        echo -n "DEBU " >>"$__logger_output"
        echo -n "$(__print_color_reset)" >>"$__logger_output"
        echo -n "$(__logfmt_escape "$1") " >>"$__logger_output"
        shift
        logfmt_print "$@"
        return
    fi

    logfmt_print_with_timestamp level debug msg "$@"
}

info() {
    if ! is_info_level_enabled; then
        return
    fi

    if [[ -n $__output_has_tty ]]; then
        echo -n "$(__faint_datestr) " >>"$__logger_output"
        echo -n "$(__print_color_bold_blue)" >>"$__logger_output"
        echo -n "INFO " >>"$__logger_output"
        echo -n "$(__print_color_reset)" >>"$__logger_output"
        echo -n "$(__logfmt_escape "$1") " >>"$__logger_output"
        shift
        logfmt_print "$@"
        return
    fi

    logfmt_print_with_timestamp level info msg "$@"
}

warn() {
    if ! is_warn_level_enabled; then
        return
    fi

    if [[ -n $__output_has_tty ]]; then
        echo -n "$(__faint_datestr) " >>"$__logger_output"
        echo -n "$(__print_color_bold_yellow)" >>"$__logger_output"
        echo -n "WARN " >>"$__logger_output"
        echo -n "$(__print_color_reset)" >>"$__logger_output"
        echo -n "$(__logfmt_escape "$1") " >>"$__logger_output"
        shift
        logfmt_print "$@"
        return
    fi

    logfmt_print_with_timestamp level warn msg "$@"
}

error() {
    if ! is_error_level_enabled; then
        return
    fi

    if [[ -n $__output_has_tty ]]; then
        echo -n "$(__faint_datestr) " >>"$__logger_output"
        echo -n "$(__print_color_bold_red)" >>"$__logger_output"
        echo -n "ERRO " >>"$__logger_output"
        echo -n "$(__print_color_reset)" >>"$__logger_output"
        echo -n "$(__logfmt_escape "$1") " >>"$__logger_output"
        shift
        logfmt_print "$@"
        return
    fi

    logfmt_print_with_timestamp level error msg "$@"
}

fatal() {
    if [[ -n $__output_has_tty ]]; then
        echo -n "$(__faint_datestr) " >>"$__logger_output"
        echo -n "$(__print_color_bold_red)" >>"$__logger_output"
        echo -n "FATA " >>"$__logger_output"
        echo -n "$(__print_color_reset)" >>"$__logger_output"
        echo -n "$(__logfmt_escape "$1") " >>"$__logger_output"
        shift
        logfmt_print "$@"
        exit 1
    fi

    logfmt_print_with_timestamp level fatal msg "$@"

    exit 1
}
