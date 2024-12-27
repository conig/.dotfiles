#!/bin/bash

# Navigate to the ~/.vaults directory
cd ~/.vaults || {
    echo "Directory ~/.vaults not found. Exiting."
    exit 1
}

# Pull the latest changes
echo "Pulling latest changes from remote repository..."
git pull || {
    echo "Failed to pull latest changes. Exiting."
    exit 1
}

# Stage all changes
echo "Staging all changes..."
git add . || {
    echo "Failed to stage changes. Exiting."
    exit 1
}

# Commit the changes with a predefined message
echo "Committing changes..."
git commit -m "auto update" || {
    echo "No changes to commit."
}

# Push the changes to the remote repository
echo "Pushing changes to remote repository..."
git push || {
    echo "Failed to push changes. Exiting."
    exit 1
}

echo "Update complete."

