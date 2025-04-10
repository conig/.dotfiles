#!/bin/bash

MOUNTPOINT="/mnt/onedrive"
REMOTE="ltu:"
RCLONE_BIN="/usr/bin/rclone"
CONFIG="$HOME/.config/rclone/rclone.conf"
LOGFILE="/tmp/rclone-watchdog.log"
RCLONE_LOG="/tmp/rclone.log"

echo "$(date) - Starting rclone mount." >> "$LOGFILE"

# Start rclone mount in background
$RCLONE_BIN mount "$REMOTE" "$MOUNTPOINT" \
    --header "Prefer: Include-Feature=AddToOneDrive" \
    --allow-other \
    --vfs-cache-mode full \
    --vfs-cache-max-size 20G \
    --vfs-cache-poll-interval 5s \
    --vfs-write-back 5s \
    --buffer-size 256M \
    --dir-cache-time 30s \
    --attr-timeout 5s \
    --fast-list \
    --async-read=true \
    --cache-dir /tmp/rclonecache \
    --config "$CONFIG" \
    --log-file "$RCLONE_LOG" \
    --tpslimit=2 \
    --tpslimit-burst=3 \
    --log-level ERROR \
    --timeout 30s \
    --contimeout 15s \
    --retries 2 \
    --low-level-retries 1 &

RCLONE_PID=$!

# Trap systemd stop signal to kill rclone and clean up
trap 'echo "$(date) - Caught SIGTERM. Cleaning up." >> "$LOGFILE"; fusermount -uz "$MOUNTPOINT"; kill $RCLONE_PID; exit 0' SIGTERM

# Watchdog loop
while true; do
    sleep 30

    # Check if rclone is still alive
    if ! ps -p "$RCLONE_PID" > /dev/null; then
        echo "$(date) - rclone process not found!" >> "$LOGFILE"
        fusermount -uz "$MOUNTPOINT"
        exit 1
    fi

    # Check internet
    if ! ping -c 1 1.1.1.1 > /dev/null 2>&1; then
        echo "$(date) - Internet connectivity lost." >> "$LOGFILE"
        fusermount -uz "$MOUNTPOINT"
        kill "$RCLONE_PID"
        exit 1
    fi

    # Check if mount is still responsive
    if ! ls "$MOUNTPOINT" > /dev/null 2>&1; then
        echo "$(date) - Mountpoint not responsive." >> "$LOGFILE"
        fusermount -uz "$MOUNTPOINT"
        kill "$RCLONE_PID"
        exit 1
    fi
done
