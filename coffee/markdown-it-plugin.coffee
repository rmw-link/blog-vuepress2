#!/usr/bin/env coffee

import {join,dirname} from 'path'
import markdownItFootnote from 'markdown-it-footnote'
import markdownItInclude from '@rmw/markdown-it-include'

module.exports = (md)=>
  md.use(markdownItFootnote)
  md.use(
    markdownItInclude
    join(dirname(dirname(__dirname)), "include")
  )

  {image} = md.renderer.rules
  md.renderer.rules.image = (tokens, idx, options, env, self) ->
    for li from tokens[idx].attrs
      if li[0] == "src"
        li[1] = li[1].replace(
          "https://raw.githubusercontent.com/gcxfd/img/gh-pages/"
          "//irmw.gumlet.io/"
        )
    image(...arguments)

  return
