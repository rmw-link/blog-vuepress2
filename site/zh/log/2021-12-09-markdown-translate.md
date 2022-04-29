# markdown 翻译工具

市面上的 markdown 翻译工具都有问题，不好用。

比如用 [menthays/markdown-translator](https://github.com/menthays/markdown-translator) 翻译 markdown 文本，会把

`对 [libmdbx](https://github.com/erthink/libmdbx) 的 rust 封装`

翻译成

`Right [libmdbx](https://github.com/erthink/libmdbx) The rust package of`。

原因是它把文本拆分为 ```{ text: '对 ' },{ text: 'libmdbx' },{ text: ' 的 rust 封装' }```分开去翻译。

而用另外一些，比如[bilingual](https://github.com/zjp-CN/bilingual/issues/22) ，又不能保持链接的样式。

我写的 `@rmw/deepl-markdown-translate` 解决了一系列问题，并且支持

* 翻译 `rust` 代码的注释文本
* 不翻译 [vuepress](https://v2.vuepress.vuejs.org/zh/reference/default-theme/frontmatter.html#prev) 中的配置字段
* 逐行缓存，节约翻译成本

对于下面文本

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/nc10t5.png)

翻译效果如下

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/CytFEw.png)

翻译需要 [deepl 的`api key`](https://www.deepl.com/pro-api)，请先去申请。( 开通需要美国信用卡，有需求可以邮件 `i@rmw.link` 帮忙代办 )。

更多说明见[代码文档](https://www.npmjs.com/package/@rmw/deepl-markdown-translate)