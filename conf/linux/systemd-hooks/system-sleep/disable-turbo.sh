#!/bin/bash
case $1/$2 in
  pre/*)
    ;;
  post/*)
    [[ -f /sys/devices/system/cpu/intel_pstate/no_turbo ]] && sudo sh -c "echo '0' > /sys/devices/system/cpu/intel_pstate/no_turbo"
    [[ -f /sys/devices/system/cpu/cpufreq/boost ]] && sudo sh -c "echo '0' > /sys/devices/system/cpu/cpufreq/boost"
    ;;
esac