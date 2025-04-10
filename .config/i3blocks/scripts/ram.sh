#!/bin/bash

ram_usage() {
    # Read total memory from /proc/meminfo (value in kB)
    mem_total=$(grep '^MemTotal:' /proc/meminfo | awk '{print $2}')

    # Try to use MemAvailable for a more accurate estimate
    mem_available=$(grep '^MemAvailable:' /proc/meminfo | awk '{print $2}')
    if [ -n "$mem_available" ]; then
        mem_used=$((mem_total - mem_available))
    else
        # Fallback for older kernels: use MemFree, Buffers and Cached
        mem_free=$(grep '^MemFree:' /proc/meminfo | awk '{print $2}')
        buffers=$(grep '^Buffers:' /proc/meminfo | awk '{print $2}')
        cached=$(grep '^Cached:' /proc/meminfo | awk '{print $2}')
        mem_used=$((mem_total - mem_free - buffers - cached))
    fi

    # Calculate RAM usage percentage
    ram_percent=$(( mem_used * 100 / mem_total ))

    # Only print if RAM usage is over 50%
    if [ "$ram_percent" -gt 50 ]; then
        echo "💾${ram_percent}%"
    fi
}

ram_usage
