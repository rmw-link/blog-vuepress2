#!/usr/bin/env coffee

import {walkRel} from '@rmw/walk'
import {hash as blake3} from 'blake3'
import {join} from 'path'
import { unpack, pack } from 'msgpackr'
import {statSync, writeFileSync, existsSync, readFileSync} from 'fs'
import {root,pwd} from './dir'

cache_path = join(pwd,'cache')
if existsSync(cache_path)
  try
    cache = unpack readFileSync cache_path
  catch err
    console.error err
    cache = {}
else
  cache = {}

cache_now = {}

zh = join root, 'site/zh'

export default (next, end)=>
  change = false

  fmt = (md)=>
    key = md[..-4]
    fp = join(zh,md)
    {mtimeMs,size,ctimeMs} = statSync fp
    mtimeMs = Math.round mtimeMs
    pre = cache[key]
    if pre
      cache_now[key] = pre
      [_size, _hash, _mtimeMs] = pre
      if mtimeMs == _mtimeMs and _size == size
        return

    txt = readFileSync fp,'utf8'
    hash = blake3 txt
    if hash == _hash
      return

    cache[key] = cache_now[key] = li = [size, hash, mtimeMs]
    if pre
      li.push pre[3] # 创建时间
    else
      li.push Math.round ctimeMs

    change = true

    console.log md, "change"
    _txt = txt.trim()
    for func from next
      try
        r = await func(_txt, md)
      catch err
        console.log md
        console.error fp
        console.error func.name
        console.error err
        continue
      if r
        _txt = r

    if _txt and _txt != txt
      writeFileSync fp,_txt


  for await md from walkRel zh
    if not md.endsWith('.md')
      continue
    await fmt md

  if change
    for i from end
      try
        await i(cache_now)
      catch err
        console.error err
    writeFileSync cache_path, pack(cache_now)
