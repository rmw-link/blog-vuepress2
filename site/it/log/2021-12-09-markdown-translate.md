# strumenti di traduzione markdown

Gli strumenti di traduzione markdown presenti sul mercato sono problematici e non funzionano bene.

Per esempio, se si usa [menthays/markdown-translator](https://github.com/menthays/markdown-translator) per tradurre il testo markdown, esso traduce

`对 [libmdbx](https://github.com/erthink/libmdbx) 的 rust 封装`

in

`Right [libmdbx](https://github.com/erthink/libmdbx) The rust package of`Il motivo è che il testo viene suddiviso in

Il motivo è che divide il testo in `{ text: '对 ' },{ text: 'libmdbx' },{ text: ' 的 rust 封装' }`per tradurlo separatamente.

L'uso di qualcosa di diverso, come il [bilingue](https://github.com/zjp-CN/bilingual/issues/22), non mantiene lo stile del link.

Ho scritto `@rmw/deepl-markdown-translate` per risolvere un certo numero di problemi e per supportare

* Tradurre il testo di commento del codice `rust`
* non traduce i campi di configurazione in [vuepress](https://v2.vuepress.vuejs.org/zh/reference/default-theme/frontmatter.html#prev)
* Caching riga per riga per risparmiare sui costi di traduzione

Per il seguente testo

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/nc10t5.png)

La traduzione funziona come segue

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/CytFEw.png)

La traduzione richiede il [sito `api key` di deepl,](https://www.deepl.com/pro-api) per [cui](https://www.deepl.com/pro-api) si prega di richiederlo prima. (Per l'apertura è necessaria una carta di credito statunitense; se ne avete bisogno, potete inviare un'e-mail a `i@rmw.link` ).

Per maggiori dettagli, consultare [la documentazione del codice](https://www.npmjs.com/package/@rmw/deepl-markdown-translate)