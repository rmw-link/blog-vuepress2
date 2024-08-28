#!/usr/bin/env coffee

{path} = require '@vuepress/utils'
coffee = require '@rmw/rollup-plugin-coffee'
pug = require 'rollup-plugin-pug'
module.exports = require('./file_url') {
plugins : [
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

plugins:[
  require './plugin'
]

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
