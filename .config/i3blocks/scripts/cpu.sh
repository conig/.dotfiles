#!/bin/bash

cpu_usage() {
    # First reading
    read -r cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
    PREV_TOTAL=$((user + nice + system + idle + iowait + irq + softirq + steal))
    PREV_IDLE=$((idle + iowait))

    # Sleep for a short period to collect the next reading
    sleep 1

    # Second reading
    read -r cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
    TOTAL=$((user + nice + system + idle + iowait + irq + softirq + steal))
    IDLE=$((idle + iowait))

    # Calculate differences between readings
    TOTAL_DIFF=$((TOTAL - PREV_TOTAL))
    IDLE_DIFF=$((IDLE - PREV_IDLE))

    # Calculate CPU usage percentage using correct differences
    CPU_USAGE=$(( (TOTAL_DIFF - IDLE_DIFF) * 100 / TOTAL_DIFF ))

    # Only print if CPU usage is over 50%
    if [ "$CPU_USAGE" -gt 50 ]; then
        echo "$CPU_USAGE%"
    fi
}

cpu_usage
