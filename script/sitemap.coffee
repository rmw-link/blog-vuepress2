#!/usr/bin/env coffee

import lang from "./lang"
import thisdir from '@rmw/thisdir'
import {createWriteStream,readFileSync} from 'fs'
import {join,dirname} from 'path'

pwd = thisdir import.meta
public_dir = join dirname(pwd),'public'
site = readFileSync(join(public_dir,'CNAME'),'utf8').trim()

export default (cache)=>
  out = writerStream = createWriteStream join(public_dir,"sitemap.xml")
  out.write """<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">"""

  li = []
  for key, i of cache
    li.push [i[3], i[2], key]
  li.sort(
    (a,b)=>b[0]-a[0]
  )

  for [ctime, mtime, key] from li
    mtime = new Date(mtime)
    mtime = mtime.toISOString().split('.',1)[0]+'+00:00'
    for l from lang
      out.write "<url><loc>https://#{site}/#{l}/#{key}.html</loc><lastmod>#{mtime}</lastmod></url>"

  out.write(
    """</urlset>"""
  )
  out.end()
  return new Promise (resolve)=>
    out.on 'finish', =>
      resolve()
