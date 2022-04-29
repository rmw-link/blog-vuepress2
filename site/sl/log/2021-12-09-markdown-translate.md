# orodja za prevajanje markdown

Orodja za prevajanje markdown na trgu so problematična in ne delujejo dobro.

Če na primer za prevajanje besedila markdown uporabite [menthays/markdown-translator](https://github.com/menthays/markdown-translator), ta prevede

`对 [libmdbx](https://github.com/erthink/libmdbx) 的 rust 封装`

v .

`Right [libmdbx](https://github.com/erthink/libmdbx) The rust package of`Razlog za to je, da se besedilo razdeli na

Razlog za to je, da besedilo razdeli na `{ text: '对 ' },{ text: 'libmdbx' },{ text: ' 的 rust 封装' }`in ga prevaja ločeno.

Uporaba česa drugega, na primer [dvojezičnega](https://github.com/zjp-CN/bilingual/issues/22), ne ohranja sloga povezave.

Napisal sem `@rmw/deepl-markdown-translate`, da bi rešil več težav in podprl

* Prevajanje besedila komentarjev kode `rust`
* ne prevaja konfiguracijskih polj v [vuepress](https://v2.vuepress.vuejs.org/zh/reference/default-theme/frontmatter.html#prev)
* Predpomnilnik po vrsticah za prihranek stroškov prevajanja

Za naslednje besedilo

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/nc10t5.png)

Prevod deluje na naslednji način

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/CytFEw.png)

Za prevod je potrebna [deeplova spletna stran `api key`, zato](https://www.deepl.com/pro-api) jo najprej zahtevajte. (Za odprtje je potrebna ameriška kreditna kartica; če jo potrebujete, lahko za pomoč pišete na `i@rmw.link` ).

Za več podrobnosti glej [dokumentacijo o kodi](https://www.npmjs.com/package/@rmw/deepl-markdown-translate)