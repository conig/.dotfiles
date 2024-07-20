#!/bin/bash

# Define backup directory
BACKUP_DIR="$HOME/.system_backups"

# Check if running with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or with sudo."
    exit 1
fi

# Restore APT repository list
sudo cp -R "$BACKUP_DIR/sources.list*" /etc/apt/
sudo cp -R "$BACKUP_DIR/sources.list.d" /etc/apt/
echo "APT repository list restored."

# Update package lists
sudo apt-get update

# Restore package selections
sudo dpkg --set-selections < "$BACKUP_DIR/package-selections.txt"
sudo apt-get dselect-upgrade -y
echo "Packages restored."

# Install manually installed packages
xargs -a "$BACKUP_DIR/manual-packages.txt" -r sudo apt-get install -y
echo "Manually installed packages restored."

# Fix broken dependencies
sudo apt-get install -f -y

echo "Restore completed!"
