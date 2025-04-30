#!/usr/bin/env bash
#
# ~/.scripts/rofi-onedrive-cache.sh
#   1) Rebuild static index into a temp file
#   2) Atomically swap it in place
#   3) Warm rclone’s VFS cache in the background

set -euo pipefail

MOUNTPOINT="/mnt/onedrive"
CACHE_DIR="$HOME/.cache/rofi-onedrive"
INDEX_FILE="$CACHE_DIR/onedrive-fd-index.txt"

# ensure cache directory exists
mkdir -p "$CACHE_DIR"

# 1) build index into a temp file in the same dir
tmp=$(mktemp "${CACHE_DIR}/onedrive-fd-index.XXXXXX")
echo "[$(date)] Rebuilding static index to $tmp…" >&2
fdfind --hidden --no-ignore --type d --type f --regex '.*' "$MOUNTPOINT" > "$tmp"

# 2) atomically move it into place
mv -f "$tmp" "$INDEX_FILE"
echo "[$(date)] Index updated at $INDEX_FILE" >&2

# 3) warm the VFS cache without blocking
echo "[$(date)] Warming rclone VFS cache in background…" >&2
nohup find "$MOUNTPOINT" -type d > /dev/null 2>&1 &

exit 0
