#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE}")/logger.sh"

echo "===== Structured Logging ====="
info "This is an info message" key1 value1 key2 value2 key3 value3
info "This message has invalid number of arguments" key1 value1 key2
info "This message need to be escaped" key1 "value with spaces" key2 "value with \"quotes\"" key3 "$(echo -e "value with\nnewline")"

echo
echo "=====  Setting log level to debug ====="
set_log_level debug
debug "This is a debug message."
info "This is an info message."
warn "This is a warning message."
error "This is an error message."

echo
echo "===== Setting log level to warn ====="
set_log_level warn
debug "This is a debug message."
info "This is an info message."
warn "This is a warning message."
error "This is an error message."

echo
echo "===== Manually testing log levels ====="
if is_debug_level_enabled; then
    echo "Debug level is enabled"
else
    echo "Debug level is disabled"
fi

echo
echo "===== Colors ====="
echo "If you run this script in a terminal, you should see the log messages in different colors. Otherwise, you should see the log messages in plain text."
