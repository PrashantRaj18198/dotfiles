#!/bin/bash

echo "Pushing to upstream"
cd ~/dotfiles/ || { echo "Failed to change directory"; exit 1; }

# Add all changes
git add .

# Commit the changes
git commit -m "Sync from local"
commit_exit_code=$?

# Check if commit was successful (exit code 0 means success)
if [[ $commit_exit_code -eq 0 ]]
then
    echo "Able to commit. Pushing the changes to upstream"
    git push
else
    echo "No changes to commit or an error occurred"
fi

echo "Sync complete"
