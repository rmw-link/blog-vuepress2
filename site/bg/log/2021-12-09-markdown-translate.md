# инструменти за превод на markdown

Инструментите за превод на маркдаун на пазара са проблематични и не работят добре.

Например, ако използвате [menthays/markdown-translator](https://github.com/menthays/markdown-translator) за превод на текст в markdown, той превежда

`对 [libmdbx](https://github.com/erthink/libmdbx) 的 rust 封装`

в

`Right [libmdbx](https://github.com/erthink/libmdbx) The rust package of`Причината за това е, че текстът се разделя на

Причината за това е, че тя разделя текста на `{ text: '对 ' },{ text: 'libmdbx' },{ text: ' 的 rust 封装' }`, за да го преведе поотделно.

Използването на нещо друго, например [двуезичен](https://github.com/zjp-CN/bilingual/issues/22), не поддържа стила на връзката.

Написах `@rmw/deepl-markdown-translate`, за да разреша редица проблеми и да поддържам

* Превод на текста на коментара на кода `rust`
* не се превеждат конфигурационни полета в [vuepress](https://v2.vuepress.vuejs.org/zh/reference/default-theme/frontmatter.html#prev)
* Кеширане на ред по ред за спестяване на разходи за превод

За следния текст

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/nc10t5.png)

Преводът работи по следния начин

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/CytFEw.png)

Преводът изисква [deepl's `api key`](https://www.deepl.com/pro-api), моля, поискайте го първо. (За да отворите, е необходима американска кредитна карта; ако имате нужда от такава, можете да изпратите имейл на `i@rmw.link` ).

Вижте [документацията за кода](https://www.npmjs.com/package/@rmw/deepl-markdown-translate) за повече подробности