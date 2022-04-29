#!/usr/bin/env coffee

import Lang from "./lang"
import {walkRel} from '@rmw/walk'
import {site} from './dir'
import {join} from 'path'
import {unlinkSync} from 'fs'

export default (cache)=>
  exist = new Set(
    i+'.md' for i from Object.keys(cache)
  )
  for lang from Lang[1..]
    dir = join site,lang
    for await i from walkRel(dir)
      if not exist.has(i)
        fp = join(dir,i)
        console.log "rm", fp
        unlinkSync fp
  return

