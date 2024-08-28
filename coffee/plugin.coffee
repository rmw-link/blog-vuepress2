#!/usr/bin/env coffee

import markdownIt from './markdown-it-plugin'
# { path } = require('@vuepress/utils')

export default {
  name:'rmw-markdown'
  multiple: false
  extendsMarkdown: markdownIt
}
