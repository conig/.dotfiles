#!/bin/bash

# Find all visible windows with class "Google-chrome"
win_id=$(xdotool search --name "Microsoft Teams" | head -n 1)

for id in $win_ids; do
    title=$(xdotool getwindowname "$id")
    if echo "$title" | grep -q "Microsoft Teams"; then
        win_id=$id
        break
    fi
done

if [ -z "$win_id" ]; then
    echo ""
    exit 0
fi

# Get the window title.
win_title=$(xdotool getwindowname "$win_id")

# Extract the number in parentheses, if present.
if [[ $win_title =~ \(([0-9]+)\) ]]; then
    echo "🔔 ${BASH_REMATCH[1]}"
else
    echo ""
fi
