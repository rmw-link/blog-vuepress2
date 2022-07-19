# markdown tõlkevahendid

Turul olevad markdown-tõlkevahendid on problemaatilised ja ei tööta hästi.

Näiteks, kui kasutate [menthays/markdown-translator'i](https://github.com/menthays/markdown-translator) markdown teksti tõlkimiseks, siis tõlgib see järgmist

`对 [libmdbx](https://github.com/erthink/libmdbx) 的 rust 封装`

aadressile

`Right [libmdbx](https://github.com/erthink/libmdbx) The rust package of`Selle põhjuseks on see, et see jagab teksti kaheks

Selle põhjuseks on see, et see jagab teksti `{ text: '对 ' },{ text: 'libmdbx' },{ text: ' 的 rust 封装' }`, et seda eraldi tõlkida.

Kasutades midagi muud, näiteks [kakskeelset](https://github.com/zjp-CN/bilingual/issues/22), ei säilita linkide stiili.

Ma kirjutasin `@rmw/deepl-markdown-translate`, et lahendada mitmeid probleeme ja toetada

* `rust` koodi kommentaariteksti tõlkimine
* ei tõlgita konfiguratsioonivälju [vuepressis](https://v2.vuepress.vuejs.org/zh/reference/default-theme/frontmatter.html#prev)
* Ridade vahemälu, et säästa tõlkekulusid

Järgmise teksti puhul

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/nc10t5.png)

Tõlge toimib järgmiselt

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/CytFEw.png)

Tõlge nõuab [deepl'i `api key`,](https://www.deepl.com/pro-api) palun küsige seda esmalt. (avamiseks on vaja USA krediitkaarti, selle avamiseks saad saata e-kirja aadressil `i@rmw.link`, kui vajad seda).

Vaata täpsemalt [koodidokumentatsioonist](https://www.npmjs.com/package/@rmw/deepl-markdown-translate)