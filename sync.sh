#!/bin/sh

set -e

GITHUB_REPO=$1
GITCODE_REPO=$2 
GETSH=$3
APPNAME=$(basename "$GITHUB_REPO" .git)

GIT_SSH_COMMAND="ssh -v"

echo "GITHUB_REPO=$GITHUB_REPO"
echo "GITCODE_REPO=$GITCODE_REPO"
echo "APPNAME=$APPNAME"
echo "GETSH=$GETSH"

#git clone --mirror "$GITHUB_REPO" && cd `basename "$GITHUB_REPO"`

if [ -z "$GETSH" ]
    then
        git clone --mirror "$GITHUB_REPO" && cd `basename "$GITHUB_REPO"`
        echo "无替换脚本！"
    else
        git clone "$GITHUB_REPO" && cd $APPNAME
        echo "开始替换操作！"
        wget $GETSH
        chmod -R 777 main.sh
        ./main.sh ${APPNAME}
        rm -rf main.sh
        echo "删除替换文件！"
        cd /github/workspace/$APPNAME
        git add .
        git commit -m '本地化'
fi

echo "开始替换远程仓库"
git remote set-url --push origin "$GITCODE_REPO"
git fetch -p origin
git for-each-ref --format 'delete %(refname)' refs/pull | git update-ref --stdin
git push --mirror
echo "同步完成"
