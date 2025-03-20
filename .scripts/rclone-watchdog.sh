#!/bin/bash
# Adjust these variables as needed
MOUNTPOINT="/mnt/onedrive"
REMOTE="ltu:"
RCLONE_BIN="/usr/bin/rclone"
CONFIG="$HOME/.config/rclone/rclone.conf"

# Construct the rclone mount command with additional timeout and retry options.
# Note that quotes remain straight.
RCLONE_CMD="$RCLONE_BIN mount $REMOTE $MOUNTPOINT \
    --header \"Prefer: Include-Feature=AddToOneDrive\" \
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
    --config $CONFIG \
    --log-file /tmp/rclone.log \
    --log-level ERROR \
    --timeout 30s \
    --contimeout 15s \
    --retries 2 \
    --low-level-retries 1"

echo "$(date) - Starting rclone mount." >> /tmp/rclone-watchdog.log
# Start rclone mount in background
eval $RCLONE_CMD &
RCLONE_PID=$!

# Monitor connectivity every 30 seconds.
while true; do
  sleep 30
  if ! ping -c 1 1.1.1.1 > /dev/null 2>&1; then
    echo "$(date) - Internet connectivity lost. Killing rclone mount." >> /tmp/rclone-watchdog.log
    fusermount -uz "$MOUNTPOINT"
    kill $RCLONE_PID
    exit 1
  fi
done
