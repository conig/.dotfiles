#!/usr/bin/env bash
#
# ~/.scripts/rofi-onedrive-cache.sh
#   Rebuild the OneDrive static index

MOUNTPOINT="/mnt/onedrive"
CACHE_DIR="$HOME/.cache/rofi-onedrive"
INDEX_FILE="$CACHE_DIR/onedrive-fd-index.txt"

# fd arguments
FDF_ARGS=( --hidden --no-ignore --type d --type f --regex '.*' )

mkdir -p "$CACHE_DIR"
echo "[$(date)] Rebuilding OneDrive index…" >&2
fdfind "${FDF_ARGS[@]}" "$MOUNTPOINT" > "$INDEX_FILE"

