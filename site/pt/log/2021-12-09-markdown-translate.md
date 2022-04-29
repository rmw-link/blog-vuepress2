# ferramentas de tradução de remarcação para baixo

As ferramentas de tradução markdown no mercado são problemáticas e não funcionam bem.

Por exemplo, se você usar o [menthays/markdown-translator](https://github.com/menthays/markdown-translator) para traduzir o texto markdown, ele traduz

`对 [libmdbx](https://github.com/erthink/libmdbx) 的 rust 封装`

para

`Right [libmdbx](https://github.com/erthink/libmdbx) The rust package of`A razão para isso é que divide o texto em

A razão disso é que ele divide o texto em `{ text: '对 ' },{ text: 'libmdbx' },{ text: ' 的 rust 封装' }`para traduzi-lo separadamente.

Usar outra coisa, como [bilingue](https://github.com/zjp-CN/bilingual/issues/22), não mantém o estilo do link.

Eu escrevi `@rmw/deepl-markdown-translate` para resolver uma série de problemas e para apoiar

* Traduzindo o texto de comentário do código `rust`
* não traduzindo os campos de configuração no [vuepress](https://v2.vuepress.vuejs.org/zh/reference/default-theme/frontmatter.html#prev)
* Caching linha a linha para poupar custos de tradução

Para o seguinte texto

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/nc10t5.png)

A tradução funciona da seguinte forma

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/CytFEw.png)

A tradução requer [o endereço `api key`,](https://www.deepl.com/pro-api) por favor, solicite-a primeiro. (Um cartão de crédito americano é necessário para abrir, você pode enviar um e-mail para `i@rmw.link` para ajudar com isso se precisar).

Consulte [a documentação do código](https://www.npmjs.com/package/@rmw/deepl-markdown-translate) para obter mais detalhes