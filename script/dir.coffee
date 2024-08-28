#!/usr/bin/env coffee
import thisdir from '@rmw/thisdir'
import {join,dirname} from 'path'
export pwd = thisdir import.meta
export root = dirname pwd
export site = join root, 'site'
export i18n = join(site, '.vuepress/i18n')
