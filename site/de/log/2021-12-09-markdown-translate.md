# Markdown-Übersetzungshilfen

Die auf dem Markt erhältlichen Markdown-Übersetzungswerkzeuge sind problematisch und funktionieren nicht gut.

Wenn Sie zum Beispiel [menthays/markdown-translator](https://github.com/menthays/markdown-translator) verwenden, um Markdown-Text zu übersetzen, wird Folgendes übersetzt

`对 [libmdbx](https://github.com/erthink/libmdbx) 的 rust 封装`

in

`Right [libmdbx](https://github.com/erthink/libmdbx) The rust package of`Der Grund dafür ist die Aufteilung des Textes in

Der Grund dafür ist, dass der Text in `{ text: '对 ' },{ text: 'libmdbx' },{ text: ' 的 rust 封装' }`aufgeteilt wird, um ihn separat zu übersetzen.

Wenn Sie etwas anderes verwenden, wie z. B. [zweisprachig](https://github.com/zjp-CN/bilingual/issues/22), wird der Linkstil nicht beibehalten.

Ich habe `@rmw/deepl-markdown-translate` geschrieben, um eine Reihe von Problemen zu lösen und um die

* Übersetzen des Kommentartextes von `rust` code
* nicht übersetzte Konfigurationsfelder in [vuepress](https://v2.vuepress.vuejs.org/zh/reference/default-theme/frontmatter.html#prev)
* Zeilenweise Zwischenspeicherung zur Einsparung von Übersetzungskosten

Für den folgenden Text

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/nc10t5.png)

Die Übersetzung funktioniert folgendermaßen

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/CytFEw.png)

Die Übersetzung erfordert [deepl's `api key`,](https://www.deepl.com/pro-api) bitte fordern Sie es zuerst an. (Für die Eröffnung ist eine US-Kreditkarte erforderlich, die Sie bei Bedarf per E-Mail an `i@rmw.link` anfordern können).

Weitere Einzelheiten finden Sie in [der Code-Dokumentation](https://www.npmjs.com/package/@rmw/deepl-markdown-translate)