#!/usr/bin/env bash

# Get the current hour and minute
current_hour=$(date +"%H")
current_minute=$(date +"%M")

# Get the current day of the week (1 = Monday, 7 = Sunday)
day_of_week=$(date +%u)

# Exit silently on weekends
if [ "$day_of_week" -gt 5 ]; then
    echo ""
    exit 0
fi

# Define pickup time (24-hour format)
pickup_hour=16
pickup_minute=30
notify_within_minutes=30         # Notify within 30 minutes *before* pickup
negative_time_minutes=10         # Continue notifying for 10 minutes *after* pickup

# Calculate total minutes since midnight
current_total_minutes=$((10#$current_hour * 60 + 10#$current_minute))
pickup_total_minutes=$((pickup_hour * 60 + pickup_minute))

# Calculate time difference
minutes_until_pickup=$((pickup_total_minutes - current_total_minutes))

if [ "$minutes_until_pickup" -ge 0 ] && [ "$minutes_until_pickup" -le "$notify_within_minutes" ]; then
    echo "🚗 ${minutes_until_pickup}m"
elif [ "$minutes_until_pickup" -lt 0 ] && [ "$minutes_until_pickup" -ge "-$negative_time_minutes" ]; then
    echo "🚨 $((-minutes_until_pickup))m late"
else
    echo ""
fi
