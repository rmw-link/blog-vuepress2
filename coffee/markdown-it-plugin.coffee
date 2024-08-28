#!/usr/bin/env coffee

{join,dirname} = require 'path'

module.exports = (md)=>
  md.use(require 'markdown-it-footnote')
  md.use(
    require '@rmw/markdown-it-include'
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
