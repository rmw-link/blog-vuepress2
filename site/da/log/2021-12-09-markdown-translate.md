# værktøjer til oversættelse af markdown

Markdown-oversættelsesværktøjerne på markedet er problematiske og fungerer ikke godt.

Hvis du f.eks. bruger [menthays/markdown-translator](https://github.com/menthays/markdown-translator) til at oversætte markdown-tekst, oversættes den til

`对 [libmdbx](https://github.com/erthink/libmdbx) 的 rust 封装`

til

`Right [libmdbx](https://github.com/erthink/libmdbx) The rust package of`Grunden til dette er, at den opdeler teksten i

Grunden til dette er, at den opdeler teksten i `{ text: '对 ' },{ text: 'libmdbx' },{ text: ' 的 rust 封装' }`for at oversætte den separat.

Hvis du bruger noget andet, f.eks. [tosproget](https://github.com/zjp-CN/bilingual/issues/22), bevarer du ikke link-stilen.

Jeg skrev `@rmw/deepl-markdown-translate` for at løse en række problemer og for at støtte

* Oversættelse af kommentarteksten til `rust` kode
* ikke oversætte konfigurationsfelter i [vuepress](https://v2.vuepress.vuejs.org/zh/reference/default-theme/frontmatter.html#prev)
* Caching linje for linje for at spare oversættelsesomkostninger

For følgende tekst

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/nc10t5.png)

Oversættelsen fungerer på følgende måde

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/CytFEw.png)

Oversættelsen kræver [deepl's `api key`](https://www.deepl.com/pro-api), anmod venligst om den først. (Der kræves et amerikansk kreditkort for at åbne en konto, du kan sende en e-mail til `i@rmw.link` for at få hjælp med dette, hvis du har brug for det).

Se [kodedokumentationen](https://www.npmjs.com/package/@rmw/deepl-markdown-translate) for yderligere oplysninger