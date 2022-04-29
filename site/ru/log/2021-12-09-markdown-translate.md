# инструменты перевода разметки

Имеющиеся на рынке инструменты для перевода уцененных текстов проблематичны и работают плохо.

Например, если вы используете [menthays/markdown-translator](https://github.com/menthays/markdown-translator) для перевода текста разметки, он переводит так

`对 [libmdbx](https://github.com/erthink/libmdbx) 的 rust 封装`

в

`Right [libmdbx](https://github.com/erthink/libmdbx) The rust package of`Причина этого заключается в том, что он разделяет текст на

Причина этого в том, что он разбивает текст на `{ text: '对 ' },{ text: 'libmdbx' },{ text: ' 的 rust 封装' }`, чтобы перевести его отдельно.

Использование чего-то другого, например, [двуязычного](https://github.com/zjp-CN/bilingual/issues/22), не поддерживает стиль ссылки.

Я написал `@rmw/deepl-markdown-translate`, чтобы решить ряд проблем и поддержать

* Перевод текста комментария кода `rust`
* не переводятся поля конфигурации в [vuepress](https://v2.vuepress.vuejs.org/zh/reference/default-theme/frontmatter.html#prev)
* Кэширование строки за строкой для экономии затрат на перевод

Для следующего текста

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/nc10t5.png)

Перевод работает следующим образом

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/CytFEw.png)

Для перевода требуется [deepl's `api key`,](https://www.deepl.com/pro-api) пожалуйста, запросите его сначала. (Для открытия требуется кредитная карта США, если нужно, вы можете написать на `i@rmw.link`, чтобы помочь с этим).

Более подробную информацию см. в [документации к коду](https://www.npmjs.com/package/@rmw/deepl-markdown-translate)