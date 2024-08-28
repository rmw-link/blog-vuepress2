#!/usr/bin/env coffee

import {path} from '@vuepress/utils'
import coffee from '@rmw/rollup-plugin-coffee'
import pug from 'rollup-plugin-pug'
import file_url from './file_url'
import myplugin from './plugin'

module.exports = file_url {
plugins : [
  myplugin
  [
    '@vuepress/plugin-palette'
    {
      preset: 'sass'
    }
  ]
]
bundlerConfig:
  viteOptions:
    plugins: [
      coffee(
        bare:true
        sourceMap:true
      )
      pug()
    ]
    css:
      preprocessorOptions:
        scss:
          charset: false
markdown:
  breaks: true
  linkify: true
  toc:
    level: [2,3,4,5,6]
  extractHeaders:
    level: [2,3,4,5,6]
  code:
    lineNumbers:false
  links:
    externalIcon: false

theme: path.join(__dirname, 'theme')
themeConfig:
  sidebarDepth: 5
  selectLanguageText: ''
  selectLanguageAriaLabel: 'lang'
  logo: '/ico.svg'
  darkMode: false
#theme: "@rmw/site-theme"

}
