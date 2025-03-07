#!/bin/sh

# git setup

export BRANCH_NAME=glaze_up_$(date +%s)

git config --global user.name 'github-actions'
git config --global user.email 'github-actions@github.com'
git config --global --add safe.directory /github/workspace

git switch --create -m $BRANCH_NAME

# make changes

/bin/glaze_up/entrypoint.sh run

if [ -n "$(git status --porcelain)" ]; then
    git add .
    git commit -m "Update dependencies"
    git push -u origin $BRANCH_NAME

    gh pr create -t "Update dependencies" -b "Update dependencies"
fi
