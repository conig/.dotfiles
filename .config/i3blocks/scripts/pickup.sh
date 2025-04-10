#!/usr/bin/env bash

# Get the current hour and minute
current_hour=$(date +"%H")
current_minute=$(date +"%M")

# Define the pickup time (16:20 in 24-hour format)
pickup_hour=16
pickup_minute=30

# Calculate the total minutes from midnight for current time and pickup time
current_total_minutes=$((current_hour * 60 + current_minute))
pickup_total_minutes=$((pickup_hour * 60 + pickup_minute))

# Check if the current time is before the pickup time
if [ "$current_total_minutes" -lt "$pickup_total_minutes" ]; then
    # Calculate the minutes until pickup
    minutes_until_pickup=$((pickup_total_minutes - current_total_minutes))
    echo "🚗 ${minutes_until_pickup}m"
else
    echo ""
fi
