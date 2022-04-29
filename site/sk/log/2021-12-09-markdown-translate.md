# nástroje na preklad markdown

Nástroje na preklad markdown na trhu sú problematické a nefungujú dobre.

Ak napríklad použijete na preklad textu markdown [menthays/markdown-translator](https://github.com/menthays/markdown-translator), preloží sa

`对 [libmdbx](https://github.com/erthink/libmdbx) 的 rust 封装`

na stránku .

`Right [libmdbx](https://github.com/erthink/libmdbx) The rust package of`Dôvodom je rozdelenie textu na

Dôvodom je rozdelenie textu na stránku `{ text: '对 ' },{ text: 'libmdbx' },{ text: ' 的 rust 封装' }`, ktorá ho prekladá samostatne.

Použitie niečoho iného, napríklad [dvojjazyčného](https://github.com/zjp-CN/bilingual/issues/22), nezachováva štýl odkazu.

Napísal som stránku `@rmw/deepl-markdown-translate`, aby som vyriešil niekoľko problémov a podporil

* Preklad textu komentára kódu `rust`
* neprekladanie konfiguračných polí v programe [vuepress](https://v2.vuepress.vuejs.org/zh/reference/default-theme/frontmatter.html#prev)
* Ukladanie do vyrovnávacej pamäte po riadkoch na úsporu nákladov na preklad

Pre nasledujúci text

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/nc10t5.png)

Preklad funguje takto

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/CytFEw.png)

Preklad si vyžaduje [deepl's `api key`](https://www.deepl.com/pro-api), prosím, vyžiadajte si ho najprv. (Na otvorenie je potrebná americká kreditná karta, ak ju potrebujete, môžete s tým pomôcť e-mailom na `i@rmw.link` ).

Viac informácií nájdete v [dokumentácii ku kódu](https://www.npmjs.com/package/@rmw/deepl-markdown-translate)