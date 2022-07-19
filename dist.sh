#!/usr/bin/env bash

_DIR=$(cd "$(dirname "$0")"; pwd)

cd $_DIR

set -ex

./script/hook.coffee
git add -u
git commit -m"." | true
git pull

npx coffee -o site/.vuepress/ -cb coffee/
npx stylus styl --ext .scss -c -o site/.vuepress/styles

cd site

#rsync -avz coffee/theme/layout site/.vuepress/theme
npx vuepress build
cd .vuepress/dist
cp 404.html index.html

cd $_DIR

./script/mini.coffee

cd $_DIR/site/.vuepress

if [ ! -d "git" ] ; then
git clone --depth=1 git@github.com:rmw-link/rmw-link.git git
fi

cd dist
ln -s ../git/.git .
git add .
git commit -m"." | true
git push -f origin master
cd $_DIR

git push
