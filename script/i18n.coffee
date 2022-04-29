#!/usr/bin/env coffee
import {homedir} from 'os'
import {join,dirname} from 'path'
import {readFileSync, mkdirSync, writeFileSync} from 'fs'
import {root} from './dir'
import translate from '@rmw/deepl-markdown-translate'
import JSON5 from 'json5'


CONFIG = JSON.parse readFileSync join(
  homedir(),".config/markdown-translate.json"
),'utf8'


# 翻译器语言支持 https://docs.microsoft.com/zh-cn/azure/cognitive-services/translator/language-support

LANG = (i.split(' ',2) for i in """
ja 日语
pt 葡萄牙语
de 德语
ru 俄语
it 意大利语
es 西班牙语
bg 保加利亚语
cs 捷克语
da 丹麦语
el 希腊语
et 爱沙尼亚语
fi 芬兰语
fr 法语
hu 匈牙利语
lt 立陶宛语
lv 拉脱维亚语
nl 荷兰语
pl 波兰语
ro 罗马尼亚语
sk 斯洛伐克语
sl 斯洛文尼亚语
sv 瑞典语
""".trim().split("\n"))

console.log LANG

console.log "记得修改 coffee/lang.coffee 和 script/lang.coffee"

i18n = join root,"site/.vuepress/i18n"
zh = join i18n,"zh"
locale_js = "locale.js"
LOCALE = (await import(join(zh,locale_js))).default
LOCALE.title = "rmw.link"
theme_js = "theme.js"
THEME = (await import(join(zh,theme_js))).default


translate_json = (obj, lang)=>
  lang = lang.toUpperCase()

  if typeof(obj) == 'string'
    if obj.indexOf('://') + 1
      return obj
    return await translate obj,lang

  if Array.isArray(obj)
    return (
      await translate_json(i, lang) for i in obj
    )

  li = []
  for k,v of obj
    if typeof(v) == 'string'
      li.push [k,v]
    else if Array.isArray(v)
      obj[k] = await translate_json(v,lang)
    else
      console.log k,v


  for [key,val] from li
    if val.indexOf("://") < 0
      obj[key] = await translate(val,lang)

  obj

do =>
  for [lang, name] from LANG
    console.log lang, name
    dir = join(i18n, lang)
    mkdirSync(dir, recursive:true)

    write = (filename, o)=>
      writeFileSync(
        join(dir,filename)
        "module.exports = "+JSON5.stringify(o)
      )
    theme = structuredClone(THEME)
    theme.selectLanguageName = name
    write(
      theme_js
      await translate_json(theme, lang)
    )
    locale = structuredClone(LOCALE)
    locale.lang = lang
    description = await translate(
      LOCALE.description
      lang.toUpperCase()
    )
    locale.description = description
    write(
      locale_js
      locale
    )
  process.exit()
