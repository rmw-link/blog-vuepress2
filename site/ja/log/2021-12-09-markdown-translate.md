# マークダウン翻訳ツール

市販のマークダウン翻訳ツールは問題が多く、うまく機能しない。

例えば、 [menthays/markdown-translator](https://github.com/menthays/markdown-translator) を使ってマークダウンのテキストを翻訳する場合、次のように翻訳されます。

`对 [libmdbx](https://github.com/erthink/libmdbx) 的 rust 封装`

に

`Right [libmdbx](https://github.com/erthink/libmdbx) The rust package of`にテキストを分割するためです。

その理由は、 `{ text: '对 ' },{ text: 'libmdbx' },{ text: ' 的 rust 封装' }`に分割して個別に翻訳するためです。

[バイリンガルの](https://github.com/zjp-CN/bilingual/issues/22) ような別のものを使うと、リンクのスタイルが保てないのです。

`@rmw/deepl-markdown-translate` を書いたのは、さまざまな問題を解決するためと、サポートするためです。

* `rust` コードのコメントテキストを翻訳する
* [vuepressの](https://v2.vuepress.vuejs.org/zh/reference/default-theme/frontmatter.html#prev) 設定フィールドが翻訳されない
* 行単位でキャッシュすることで翻訳コストを削減

以下の文章について

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/nc10t5.png)

翻訳の仕組みは以下の通りです。

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/CytFEw.png)

翻訳には [deeplの`api key` 、](https://www.deepl.com/pro-api)まずリクエストしてください。(開設には米国のクレジットカードが必要です。必要な場合は、 `i@rmw.link` にメールしてください）。

詳しくは[コードドキュメントを](https://www.npmjs.com/package/@rmw/deepl-markdown-translate)ご覧ください