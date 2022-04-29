#!/usr/bin/env coffee

{ path } = require '@vuepress/utils'

module.exports = {
  name: 'rmw-theme'
  extends: '@vuepress/theme-default'
  layouts:
    404: path.resolve(__dirname, 'layout/404.vue')

}
