# verktyg för översättning av markdown

De verktyg för översättning av markdown som finns på marknaden är problematiska och fungerar dåligt.

Om du till exempel använder [menthays/markdown-translator](https://github.com/menthays/markdown-translator) för att översätta markdown-text översätts följande

`对 [libmdbx](https://github.com/erthink/libmdbx) 的 rust 封装`

till

`Right [libmdbx](https://github.com/erthink/libmdbx) The rust package of`Anledningen till detta är att texten delas upp i

Anledningen till detta är att texten delas upp i `{ text: '对 ' },{ text: 'libmdbx' },{ text: ' 的 rust 封装' }`för att översättas separat.

Om du använder något annat, till exempel [tvåspråkigt](https://github.com/zjp-CN/bilingual/issues/22), behåller du inte länkstilen.

Jag skrev `@rmw/deepl-markdown-translate` för att lösa ett antal problem och för att stödja

* Översättning av kommentartexten i `rust` -koden
* Konfigurationsfält i [vuepress](https://v2.vuepress.vuejs.org/zh/reference/default-theme/frontmatter.html#prev) översätts inte
* Cachelagring rad för rad för att spara översättningskostnader

För följande text

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/nc10t5.png)

Översättningen fungerar på följande sätt

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/CytFEw.png)

Översättningen kräver [deepls `api key`](https://www.deepl.com/pro-api), vänligen begär den först. (Ett amerikanskt kreditkort krävs för att öppna, du kan skicka ett e-postmeddelande till `i@rmw.link` för att få hjälp med detta om du behöver det).

Se [koddokumentationen](https://www.npmjs.com/package/@rmw/deepl-markdown-translate) för mer information.