# markdown překladatelské nástroje

Nástroje pro překlad markdown na trhu jsou problematické a nefungují dobře.

Pokud například použijete k překladu textu markdown nástroj [menthays/markdown-translator](https://github.com/menthays/markdown-translator), přeloží se tento text takto

`对 [libmdbx](https://github.com/erthink/libmdbx) 的 rust 封装`

na

`Right [libmdbx](https://github.com/erthink/libmdbx) The rust package of`Důvodem je, že se text rozdělí na.

Důvodem je rozdělení textu na stránky `{ text: '对 ' },{ text: 'libmdbx' },{ text: ' 的 rust 封装' }`, které se překládají samostatně.

Použití něčeho jiného, například [dvojjazyčného](https://github.com/zjp-CN/bilingual/issues/22), nezachovává styl odkazu.

Napsal jsem `@rmw/deepl-markdown-translate`, abych vyřešil řadu problémů a podpořil

* Překlad textu komentáře kódu `rust`
* nepřekládá pole konfigurace v aplikaci [vuepress](https://v2.vuepress.vuejs.org/zh/reference/default-theme/frontmatter.html#prev)
* Ukládání do mezipaměti řádek po řádku pro úsporu nákladů na překlad

Pro následující text

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/nc10t5.png)

Překlad funguje takto

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/CytFEw.png)

Překlad vyžaduje [deepl's `api key`](https://www.deepl.com/pro-api), vyžádejte si jej prosím nejprve. (K otevření je nutná americká kreditní karta, pokud ji potřebujete, můžete s tím pomoci e-mailem na adrese `i@rmw.link` ).

Další podrobnosti naleznete v [dokumentaci ke kódu](https://www.npmjs.com/package/@rmw/deepl-markdown-translate)