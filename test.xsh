#!/usr/bin/env xonsh

p"~/.xonshrc".exists() && source ~/.xonshrc

from os.path import dirname,abspath

PWD = dirname(abspath(__file__))
cd @(PWD)


for i in "en ja pt de ru it es bg cs da el et fi fr hu lt lv nl pl ro sk sl sv".split(' '):
  rm -rf site/@(i)/**/*.md


