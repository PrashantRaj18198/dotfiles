#!/bin/bash

# Define the cache directory
CACHE_DIR="$HOME/Library/Caches"

# Function to delete cache files
cleanup_caches() {
    echo "Starting cache cleanup..."

    # Check if the cache directory exists
    if [ -d "$CACHE_DIR" ]; then
        # Use find to delete all files and directories in the cache directory
        find "$CACHE_DIR" -mindepth 1 -print -exec rm -rf {} \; 2>/dev/null

        # Check for errors
        if [ $? -eq 0 ]; then
            echo "Cache cleanup completed successfully."
        else
            echo "Some cache directories could not be deleted due to permissions."
        fi
    else
        echo "Cache directory not found!"
    fi
}

# Prompt user for confirmation
read -p "This will delete all user cache files. Do you want to proceed? (y/n): " confirmation
if [[ "$confirmation" =~ ^[Yy]$ ]]; then
    cleanup_caches
else
    echo "Operation cancelled."
fi

