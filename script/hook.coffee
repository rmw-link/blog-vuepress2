#!/usr/bin/env coffee

import { padMarkdown } from 'md-padding'
import change from './change'
import cleanup from './cleanup'
import sitemap from './sitemap'
import translate from './translate'

do =>
  await change(
    [
      (txt)=>padMarkdown(txt)
      translate
    ]
    [
      cleanup
      sitemap
    ]
  )

  process.exit()
