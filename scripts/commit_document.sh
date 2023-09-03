#!/bin/bash

set -eux

git rm -fr docs

git commit -m "Temporary"

mv build docs

git add docs

git stash

git fetch --no-tags --depth=1 origin gh-pages

git checkout gh-pages

buildPath=docs$(cat .sub-path)

if [ ${buildPath} = docs ] ; then
    # 以下の格納ディレクトリを除くファイル・ディレクトリを削除する
    # nightly ... developブランチに対応
    # セマンティックバージョン ... タグに対応
    # 整数 ... プルリクエストに対応
    cd docs
    git rm -fr --ignore-unmatch $(ls | grep -vE '^(\d+|\d+\.\d+\.\d+|nightly)$')
    cd ..
else
    git rm -fr --ignore-unmatch ${buildPath}
fi

ammend=""
if [ -n "$(git status --short)" ]; then
    git commit -m "WIP"
	ammend="--amend"
fi

git stash pop

git commit ${ammend} -m "Update document"
