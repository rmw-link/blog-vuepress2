#!/usr/bin/env coffee
import {homedir} from 'os'
import {join,dirname} from 'path'
import {readFileSync, readdirSync, mkdirSync, writeFileSync} from 'fs'
import {root, i18n} from './dir'
import translate from '@rmw/deepl-markdown-translate'
import pLimit from 'p-limit'
import sleep from 'await-sleep'

limit = pLimit 2

lang_li = readdirSync(i18n)
lang_li.splice lang_li.indexOf('zh'),1

site = join root,"site"

_translate = (md, txt, lang)=>
  limit =>
    fp = join(site,lang,md)
    mkdirSync dirname(fp),recursive:true
    console.log "#{md} translate #{lang}"
    out = await translate(
      txt
      lang
    )
    writeFileSync(
      fp
      out
    )
    return


replace = [
  ['北海','Kraken']
  ['人民网络','rmw.link']
]


export default (txt, md)=>
  for [f,t] from replace
    txt = txt.replaceAll f,t

  li = []

  for lang from lang_li
    li.push _translate(md, txt, lang)

  await Promise.all li
  return
