# markdown translation tools

All markdown translation tools on the market have problems and don't work well.

For example, if you use [menthays/markdown-translator](https://github.com/menthays/markdown-translator) to translate markdown text, it will translate

`对 [libmdbx](https://github.com/erthink/libmdbx) 的 rust 封装`

into

`Right [libmdbx](https://github.com/erthink/libmdbx) The rust package of`The reason is that it splits the text into

The reason is that it splits the text into `{ text: '对 ' },{ text: 'libmdbx' },{ text: ' 的 rust 封装' }`to translate it separately.

Using something else, like [bilingual](https://github.com/zjp-CN/bilingual/issues/22), doesn't keep the link style.

I wrote `@rmw/deepl-markdown-translate` to solve a number of problems and to support

* Translating the comment text of `rust` code
* Not translating configuration fields in [vuepress](https://v2.vuepress.vuejs.org/zh/reference/default-theme/frontmatter.html#prev)
* Caching line by line to save translation costs

For the following text

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/nc10t5.png)

the translation works as follows

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/CytFEw.png)

The translation requires [deepl's `api key`,](https://www.deepl.com/pro-api) please apply first. ( U.S. credit card is required to open, you can email `i@rmw.link` to help do it for you if you need).

See [the code documentation](https://www.npmjs.com/package/@rmw/deepl-markdown-translate) for more details