#!/bin/bash

echo "Pushing to upstream"
cd ~/dotfiles/

git add .
commit_exit_code=$(git commit -m "Sync from local")
if [[ $commit_exit_code -eq 0 ]]
then
	echo "Able to commit. Pushing the changes to upstream"
	git push
fi

echo "Sync complete"

