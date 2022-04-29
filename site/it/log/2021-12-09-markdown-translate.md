# strumenti di traduzione markdown

Gli strumenti di traduzione markdown sul mercato sono problematici e non funzionano bene.

Per esempio, se usate [menthays/markdown-translator](https://github.com/menthays/markdown-translator) per tradurre il testo markdown, esso traduce

`对 [libmdbx](https://github.com/erthink/libmdbx) 的 rust 封装`

in

`Right [libmdbx](https://github.com/erthink/libmdbx) The rust package of`La ragione di questo è che divide il testo in

Il motivo è che divide il testo in `{ text: '对 ' },{ text: 'libmdbx' },{ text: ' 的 rust 封装' }`per tradurlo separatamente.

Usare qualcos'altro, come il [bilingue](https://github.com/zjp-CN/bilingual/issues/22), non mantiene lo stile del link.

Ho scritto `@rmw/deepl-markdown-translate` per risolvere una serie di problemi e per supportare

* Tradurre il testo di commento del codice `rust`
* non tradurre i campi di configurazione in [vuepress](https://v2.vuepress.vuejs.org/zh/reference/default-theme/frontmatter.html#prev)
* Caching riga per riga per risparmiare i costi di traduzione

Per il seguente testo

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/nc10t5.png)

La traduzione funziona come segue

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/CytFEw.png)

La traduzione richiede il [`api key`](https://www.deepl.com/pro-api) di deepl, richiedetelo prima. (Una carta di credito statunitense è necessaria per aprire, potete inviare un'email a `i@rmw.link` per aiutarvi con questo se ne avete bisogno).

Vedere la [documentazione del codice](https://www.npmjs.com/package/@rmw/deepl-markdown-translate) per maggiori dettagli