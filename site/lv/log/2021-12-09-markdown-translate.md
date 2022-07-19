# Markdown tulkošanas rīki

Tirgū pieejamie marķējuma tulkošanas rīki ir problemātiski un nedarbojas labi.

Piemēram, ja lietojat [menthays/markdown-translator](https://github.com/menthays/markdown-translator), lai tulkotu marķējuma tekstu, tas tulko šādu tekstu

`对 [libmdbx](https://github.com/erthink/libmdbx) 的 rust 封装`

uz

`Right [libmdbx](https://github.com/erthink/libmdbx) The rust package of`Iemesls tam ir tāds, ka teksts tiek sadalīts šādās daļās.

Tas tiek darīts tāpēc, ka teksts tiek sadalīts vietnē `{ text: '对 ' },{ text: 'libmdbx' },{ text: ' 的 rust 封装' }`, lai to tulkotu atsevišķi.

Izmantojot kaut ko citu, piemēram, [divvalodu](https://github.com/zjp-CN/bilingual/issues/22), netiek saglabāts saites stils.

Es uzrakstīju `@rmw/deepl-markdown-translate`, lai atrisinātu vairākas problēmas un atbalstītu

* `rust` koda komentāru teksta tulkošana
* nav tulkojot konfigurācijas laukus [vuepress](https://v2.vuepress.vuejs.org/zh/reference/default-theme/frontmatter.html#prev)
* Kešēšana pa rindiņām, lai ietaupītu tulkošanas izmaksas

Šādam tekstam

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/nc10t5.png)

Tulkojums darbojas šādi

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/CytFEw.png)

Tulkojumam ir nepieciešams [deepl's `api key`](https://www.deepl.com/pro-api), lūdzu, vispirms to pieprasiet. (Lai atvērtu kontu, ir nepieciešama ASV kredītkarte, un, ja nepieciešams, varat rakstīt uz `i@rmw.link`, lai jums palīdzētu to izdarīt).

Sīkāku informāciju skatiet [koda dokumentācijā](https://www.npmjs.com/package/@rmw/deepl-markdown-translate)