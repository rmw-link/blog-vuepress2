# instrumente de traducere markdown

Instrumentele de traducere markdown de pe piață sunt problematice și nu funcționează bine.

De exemplu, dacă folosiți [menthays/markdown-translator](https://github.com/menthays/markdown-translator) pentru a traduce textul markdown, acesta traduce

`对 [libmdbx](https://github.com/erthink/libmdbx) 的 rust 封装`

în

`Right [libmdbx](https://github.com/erthink/libmdbx) The rust package of`Motivul pentru aceasta este că împarte textul în

Motivul este că acesta împarte textul în `{ text: '对 ' },{ text: 'libmdbx' },{ text: ' 的 rust 封装' }`pentru a-l traduce separat.

Dacă se folosește altceva, cum ar fi [bilingv](https://github.com/zjp-CN/bilingual/issues/22), nu se păstrează stilul de legătură.

Am scris `@rmw/deepl-markdown-translate` pentru a rezolva o serie de probleme și pentru a sprijini

* Traducerea textului comentariilor din codul `rust`
* nu se traduc câmpurile de configurare în [vuepress](https://v2.vuepress.vuejs.org/zh/reference/default-theme/frontmatter.html#prev)
* Caching linie cu linie pentru a economisi costurile de traducere

Pentru următorul text

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/nc10t5.png)

Traducerea funcționează după cum urmează

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/CytFEw.png)

Traducerea necesită traducerea [lui deepl's `api key`,](https://www.deepl.com/pro-api) vă rugăm să o solicitați în prealabil. (Este necesar un card de credit din SUA pentru a deschide un cont, puteți trimite un e-mail la `i@rmw.link` pentru a vă ajuta cu acest lucru dacă aveți nevoie).

Consultați [documentația codului](https://www.npmjs.com/package/@rmw/deepl-markdown-translate) pentru mai multe detalii