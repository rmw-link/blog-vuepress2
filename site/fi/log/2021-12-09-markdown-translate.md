# markdown-käännöstyökalut

Markkinoilla olevat markdown-käännöstyökalut ovat ongelmallisia eivätkä toimi hyvin.

Jos esimerkiksi käytät [menthays/markdown-kääntäjää](https://github.com/menthays/markdown-translator) kääntämään markdown-tekstiä, se kääntää

`对 [libmdbx](https://github.com/erthink/libmdbx) 的 rust 封装`

osoitteeseen

`Right [libmdbx](https://github.com/erthink/libmdbx) The rust package of`Syy tähän on se, että se jakaa tekstin seuraaviin osiin

Tämä johtuu siitä, että se jakaa tekstin osoitteeseen `{ text: '对 ' },{ text: 'libmdbx' },{ text: ' 的 rust 封装' }`, jotta se voidaan kääntää erikseen.

Jos käytät jotain muuta, kuten [kaksikielistä](https://github.com/zjp-CN/bilingual/issues/22), linkin tyyli ei säily [.](https://github.com/zjp-CN/bilingual/issues/22)

Kirjoitin `@rmw/deepl-markdown-translate` ratkaistakseni useita ongelmia ja tukeakseni

* `rust` koodin kommenttitekstin kääntäminen.
* ei käännetä konfigurointikenttiä [vuepressissä](https://v2.vuepress.vuejs.org/zh/reference/default-theme/frontmatter.html#prev)
* Rivikohtainen välimuistitallennus käännöskustannusten säästämiseksi

Seuraavan tekstin osalta

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/nc10t5.png)

Käännös toimii seuraavasti

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/CytFEw.png)

Käännös vaatii [deeplin `api key`,](https://www.deepl.com/pro-api) pyydä sitä ensin. (Avaamiseen tarvitaan yhdysvaltalainen luottokortti, voit lähettää sähköpostia osoitteeseen `i@rmw.link`, jos tarvitset apua tämän kanssa).

Katso lisätietoja [koodin dokumentaatiosta](https://www.npmjs.com/package/@rmw/deepl-markdown-translate)