#!/usr/bin/env coffee

{dirname,join} = require 'path'
fs = require 'fs'
walk = require './lib/walk'
readline = require('readline')

module.exports = (config)=>
  pwd = __dirname
  root = dirname __dirname
  {themeConfig} = config
  config.locales = {}
  themeConfig.locales = theme = {}
  i18n = join(pwd, 'i18n')
  for lang from require './lang'
    url = '/'+lang

    config.locales[url] = require join i18n, lang,'locale'
    t = theme[url] = require join i18n, lang,'theme'

    url += '/'
    t.sidebar = sidebar = []

    dir_map = new Map()
    dir_name = new Map()
    dir = join root,lang
    for await fp from walk dir
      if fp.endsWith '.md'
        p = fp[..-4]
        pos = p.indexOf('/')
        if p.endsWith 'readme'
          p = p[..-8]
          if pos > 0
            s = fs.createReadStream join(dir,fp),'utf8'
            rl = readline.createInterface({
              input: s
              crlfDelay: Infinity
            })
            for await line from rl
              if line.startsWith "# "
                dir_name.set(p, line[2..].trim())
                break
            s.close()
            continue
        if pos > 0
          k = p[...pos]
          li = dir_map.get k
          if li
            li.push url+p
          else
            dir_map.set k, [url+p]
        else
          sidebar.push url+p

    for [k,li] from dir_map.entries()
      sidebar.push {
        link: url+k
        text: dir_name.get(k)
        children: li
      }

    sidebar.sort (a,b)=>
      a.length - b.length
  return config
