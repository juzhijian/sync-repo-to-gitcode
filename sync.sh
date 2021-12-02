#!/bin/sh

set -e

GITHUB_REPO=$1
CODING_REPO=$2
GETSH=$3

GIT_SSH_COMMAND="ssh -v"

echo "GITHUB_REPO=$GITHUB_REPO"
echo "CODING_REPO=$CODING_REPO"
echo "GETSH=$GETSH"

git clone --mirror "$GITHUB_REPO" && cd `basename "$GITHUB_REPO"`

if [-n “$GETSH” ];then
    wget $GETSH
    chmod -R 777 main.sh
    ./main.sh
fi

git remote set-url --push origin "$CODING_REPO"
git fetch -p origin
git for-each-ref --format 'delete %(refname)' refs/pull | git update-ref --stdin
git push --mirror