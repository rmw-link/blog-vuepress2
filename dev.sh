#!/usr/bin/env bash

DIR=$(cd "$(dirname "$0")"; pwd)
set -x
cd $DIR

. .direnv/bin/pid.sh

while true; do
npx concurrently --kill-others \
  "cd site && npx vuepress dev"\
  "npx coffee -o site/.vuepress/ -cbw coffee/"\
  "npx stylus -w styl --ext .scss -c -o site/.vuepress/styles"

echo "restart after 10 seconds"
sleep 10
done
