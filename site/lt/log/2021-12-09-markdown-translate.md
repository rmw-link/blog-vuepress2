# Markdown vertimo įrankiai

Rinkoje esantys žymėjimo vertimo įrankiai yra problemiški ir neveikia gerai.

Pavyzdžiui, jei naudojate [menthays/markdown-translator](https://github.com/menthays/markdown-translator), kad išverstumėte markdown tekstą, jis išverčia

`对 [libmdbx](https://github.com/erthink/libmdbx) 的 rust 封装`

į

`Right [libmdbx](https://github.com/erthink/libmdbx) The rust package of`Taip yra todėl, kad tekstas padalijamas į

Taip yra dėl to, kad tekstas padalijamas į `{ text: '对 ' },{ text: 'libmdbx' },{ text: ' 的 rust 封装' }`, kad būtų galima jį atskirai išversti.

Naudojant ką nors kita, pavyzdžiui, [dvikalbę](https://github.com/zjp-CN/bilingual/issues/22), nuorodos stilius neišlaikomas.

Parašiau `@rmw/deepl-markdown-translate`, kad išspręsčiau keletą problemų ir palaikyčiau

* `rust` kodo komentarų teksto vertimas
* neišversti konfigūracijos laukų [vuepress](https://v2.vuepress.vuejs.org/zh/reference/default-theme/frontmatter.html#prev)
* Spartinančioji eilutė po eilutės, kad sutaupytumėte vertimo išlaidas

Dėl šio teksto

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/nc10t5.png)

Vertimas veikia taip

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/CytFEw.png)

Vertimui reikia [deepl's `api key`](https://www.deepl.com/pro-api), prašome pirmiausia jo paprašyti. (Norint atidaryti sąskaitą, reikia turėti JAV kredito kortelę; jei reikia, galite parašyti el. paštu `i@rmw.link`, kad padėtų tai padaryti).

Daugiau informacijos rasite [kodo dokumentacijoje](https://www.npmjs.com/package/@rmw/deepl-markdown-translate)