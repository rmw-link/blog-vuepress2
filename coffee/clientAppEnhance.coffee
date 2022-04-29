#!/usr/bin/env coffee
import {routeLocaleSymbol, defineClientAppEnhance } from '@vuepress/client'
import {themeData} from '@vuepress/plugin-theme-data/lib/client'



export default defineClientAppEnhance ({
  app, router, siteData
}) =>

  if __VUEPRESS_SSR__
    return

  ((m, e, t, r, i, k, a) ->
    m[i] = m[i] or ->
      (m[i].a = m[i].a or []).push arguments
      return
    m[i].l = 1 * new Date
    k = e.createElement(t)
    a = e.getElementsByTagName(t)[0]
    k.async = 1
    k.src = r
    a.parentNode.insertBefore(k, a)
    return
  ) window, document, 'script', '//mc.yandex.ru/metrika/tag.js', 'ym'
  ym 86833545, 'init',
    clickmap: true
    trackLinks: true
    accurateTrackBounce: true
    webvisor: true

  {value:site} = siteData

  {locales} = site

  theme = themeData.value.locales
  slash = '/'
  for lang from [
    navigator.language.split('-')[0]
    'en'
  ]
    lang = slash+lang
    o = locales[lang]
    if o
      for k,v of o
        site[k] = v
      theme[slash] = theme[lang]
      break

  len = lang.length
  lang += slash
  for i in router.getRoutes()
    {path} = i
    if path.startsWith lang
      router.addRoute {
        path:path[len..]
        redirect:path
      }

  return
