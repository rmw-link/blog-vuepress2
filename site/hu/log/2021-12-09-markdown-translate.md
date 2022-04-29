# markdown fordítási eszközök

A piacon lévő markdown fordítási eszközök problémásak és nem működnek jól.

Például, ha a [menthays/markdown-translator-t](https://github.com/menthays/markdown-translator) használja a markdown szöveg lefordításához, akkor a következőket fordítja le

`对 [libmdbx](https://github.com/erthink/libmdbx) 的 rust 封装`

a címre.

`Right [libmdbx](https://github.com/erthink/libmdbx) The rust package of` .

Ennek oka, hogy a szöveget a `{ text: '对 ' },{ text: 'libmdbx' },{ text: ' 的 rust 封装' }`oldalra bontja és külön-külön fordítja le.

Ha valami mást használ, például [kétnyelvű](https://github.com/zjp-CN/bilingual/issues/22), nem tartja meg a linkek stílusát.

A `@rmw/deepl-markdown-translate` -t azért írtam, hogy megoldjak egy sor problémát és támogassam a

* A `rust` kód kommentárszövegének fordítása
* nem fordítja le a konfigurációs mezőket a [vuepressben](https://v2.vuepress.vuejs.org/zh/reference/default-theme/frontmatter.html#prev)
* Cache soronként a fordítási költségek megtakarítása érdekében

A következő szöveg esetében

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/nc10t5.png)

A fordítás a következőképpen működik

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/CytFEw.png)

A fordításhoz [deepl's `api key`](https://www.deepl.com/pro-api) szükséges, kérjük, előbb kérdezze meg. (A megnyitáshoz amerikai hitelkártyára van szükség, ha szüksége van rá, küldjön e-mailt a `i@rmw.link` címre, hogy segítsen ebben).

További részletekért lásd [a kód dokumentációját](https://www.npmjs.com/package/@rmw/deepl-markdown-translate)