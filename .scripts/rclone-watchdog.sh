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
  --vfs-cache-mode writes \
  --vfs-cache-max-size 20G \
  --vfs-write-back 30s \
  --dir-cache-time 1h \
  --onedrive-delta \
  --vfs-fast-fingerprint \
  --tpslimit 10 --tpslimit-burst 10 \
  --cache-dir ~/.cache/rclone/vfs \
  --log-level INFO \
  --rc &

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
