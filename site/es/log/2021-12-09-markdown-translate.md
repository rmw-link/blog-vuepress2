# herramientas de traducción de markdown

Las herramientas de traducción de markdown del mercado son problemáticas y no funcionan bien.

Por ejemplo, si utiliza [menthays/markdown-translator](https://github.com/menthays/markdown-translator) para traducir el texto de markdown, éste traduce

`对 [libmdbx](https://github.com/erthink/libmdbx) 的 rust 封装`

en

`Right [libmdbx](https://github.com/erthink/libmdbx) The rust package of`La razón es que divide el texto en

La razón es que divide el texto en `{ text: '对 ' },{ text: 'libmdbx' },{ text: ' 的 rust 封装' }`para traducirlo por separado.

Utilizar otra cosa, como [el bilingüe](https://github.com/zjp-CN/bilingual/issues/22), no mantiene el estilo de los enlaces.

Escribí `@rmw/deepl-markdown-translate` para resolver una serie de problemas y para apoyar

* Traducción del texto de los comentarios del código `rust`
* no traducir los campos de configuración en [vuepress](https://v2.vuepress.vuejs.org/zh/reference/default-theme/frontmatter.html#prev)
* Almacenamiento en caché línea por línea para ahorrar costes de traducción

Para el siguiente texto

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/nc10t5.png)

La traducción funciona de la siguiente manera

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/CytFEw.png)

La traducción requiere [deepl's `api key`,](https://www.deepl.com/pro-api) por favor solicítela primero. (Se requiere una tarjeta de crédito de EE.UU. para abrir, puede enviar un correo electrónico a `i@rmw.link` para ayudar con esto si lo necesita).

Consulte [la documentación del código](https://www.npmjs.com/package/@rmw/deepl-markdown-translate) para obtener más detalles