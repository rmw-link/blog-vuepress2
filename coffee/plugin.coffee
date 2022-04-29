#!/usr/bin/env coffee

fs = require 'fs'
{ path } = require('@vuepress/utils')

module.exports = {
  name:'rmw-markdown'
  multiple: false
  extendsMarkdown: require './markdown-it-plugin'
}
