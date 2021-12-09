#!/bin/sh

set -e

GITHUB_REPO=$1
CODING_REPO=$2
GETSH=$3

GIT_SSH_COMMAND="ssh -v"

echo "GITHUB_REPO=$GITHUB_REPO"
echo "CODING_REPO=$CODING_REPO"
echo "GETSH=$GETSH"

#git clone --mirror "$GITHUB_REPO" && cd `basename "$GITHUB_REPO"`
pwd
git clone "$GITHUB_REPO" && cd `basename "$GITHUB_REPO"`
pwd
if [ -z "$GETSH" ]
    then
        echo "无替换脚本！"
    else 
        echo "开始替换操作！"
        wget $GETSH
        chmod -R 777 main.sh
        ./main.sh
        echo "替换完成！"
        rm -rf main.sh
        echo "删除替换文件！"
        #git add .
        #git commit -m '本地化测试'
fi

echo "替换远程仓库"
git remote set-url --push origin "$CODING_REPO"
git fetch -p origin
git for-each-ref --format 'delete %(refname)' refs/pull | git update-ref --stdin
git push --mirror
echo "同步完成"
