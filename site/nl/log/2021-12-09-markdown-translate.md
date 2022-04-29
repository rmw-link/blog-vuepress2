# markdown vertaalhulpmiddelen

De markdown vertaalhulpmiddelen op de markt zijn problematisch en werken niet goed.

Bijvoorbeeld, als je [menthays/markdown-translator](https://github.com/menthays/markdown-translator) gebruikt om markdown tekst te vertalen, vertaalt het

`对 [libmdbx](https://github.com/erthink/libmdbx) 的 rust 封装`

in

`Right [libmdbx](https://github.com/erthink/libmdbx) The rust package of`De reden hiervoor is dat het de tekst splitst in

De reden hiervoor is dat de tekst wordt opgesplitst in `{ text: '对 ' },{ text: 'libmdbx' },{ text: ' 的 rust 封装' }`om deze afzonderlijk te vertalen.

Iets anders gebruiken, zoals [tweetalig](https://github.com/zjp-CN/bilingual/issues/22), houdt de linkstijl niet in stand.

Ik schreef `@rmw/deepl-markdown-translate` om een aantal problemen op te lossen en om

* Het vertalen van de commentaar tekst van `rust` code
* configuratievelden in [vuepress](https://v2.vuepress.vuejs.org/zh/reference/default-theme/frontmatter.html#prev) worden niet vertaald
* Caching regel voor regel om vertaalkosten te besparen

Voor de volgende tekst

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/nc10t5.png)

De vertaling werkt als volgt

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/CytFEw.png)

De vertaling vereist [deepl's `api key`,](https://www.deepl.com/pro-api) vraag het eerst aan. (Een Amerikaanse creditcard is vereist om te openen, u kunt een e-mail sturen naar `i@rmw.link` om u hiermee te helpen als dat nodig is).

Zie [de documentatie bij de code](https://www.npmjs.com/package/@rmw/deepl-markdown-translate) voor meer details