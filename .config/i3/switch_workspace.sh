#!/bin/sh

# Usage: ./switch_workspace.sh <workspace_name>
TARGET="$1"

# Get the currently focused workspace name
CURRENT=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name')

# If the current workspace is not the target, switch
if [ "$CURRENT" != "$TARGET" ]; then
  i3-msg workspace "$TARGET"
fi

