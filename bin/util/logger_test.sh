#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE}")/logger.sh"

echo "===== Structured Logging ====="
info "This is an info message with other key values" key1 value1 key2 value2 key3 value3

echo
echo "=====  Setting log level to debug ====="
set_log_level debug
debug "This is a debug message." # This message should be displayed
info "This is an info message."
warn "This is a warning message."
error "This is an error message."

echo
echo "===== Setting log level to warn ====="
set_log_level warn
debug "This is a debug message." # This message should not be displayed
info "This is an info message." # This message should not be displayed
warn "This is a warning message."
error "This is an error message."

echo
echo "===== Manually testing log levels ====="
if is_debug_level_enabled; then
    echo "Debug level is enabled"
else
    echo "Debug level is disabled"
fi
if is_info_level_enabled; then
    echo "Info level is enabled"
else
    echo "Info level is disabled"
fi
if is_warn_level_enabled; then
    echo "Warn level is enabled"
else
    echo "Warn level is disabled"
fi
if is_error_level_enabled; then
    echo "Error level is enabled"
else
    echo "Error level is disabled"
fi

echo
echo "===== Special cases ====="
set_log_level debug
debug "This message has a key with no value." key1 value1 invalid_key
for i in  "!" "@" "#" "$" "%" "^" "&" "*" "(" ")" "[" "]" "{" "}" "-" "_" "+" ";" "'" ":" "," "." "<" ">" "/" "?" "\`" "~" "|" "\\" "=" "\"" " " "$(echo -en "1\n2")" "$(echo -en "\r")" "$(echo -en "\t")" "$(echo -en "\v")" "$(echo -en "\f")" "$(echo -en "\b")"; do
    debug "This message has special characters." character "$i"
done
debug "This message need to be escaped." key1 "value with spaces" key2 "value with \"quotes\"" key3 "$(echo -e "value with\nnewline")"

echo
echo "===== Colors ====="
echo "If you run this script in a terminal, you should see the log messages in different colors. Otherwise, you should see the log messages in plain text."
