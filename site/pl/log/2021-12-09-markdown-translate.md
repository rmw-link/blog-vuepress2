# narzędzia do tłumaczenia markdown

Dostępne na rynku narzędzia do tłumaczenia markdown są problematyczne i nie działają dobrze.

Na przykład, jeśli użyjesz [menthays/markdown-translator](https://github.com/menthays/markdown-translator) do tłumaczenia tekstu markdown, to przetłumaczy on

`对 [libmdbx](https://github.com/erthink/libmdbx) 的 rust 封装`

na stronę

`Right [libmdbx](https://github.com/erthink/libmdbx) The rust package of`Powodem tego jest to, że tekst jest dzielony na

Powodem tego jest podział tekstu na `{ text: '对 ' },{ text: 'libmdbx' },{ text: ' 的 rust 封装' }`w celu oddzielnego przetłumaczenia.

Użycie czegoś innego, np. [dwujęzycznego](https://github.com/zjp-CN/bilingual/issues/22), nie pozwala zachować stylu łącza.

Napisałem `@rmw/deepl-markdown-translate`, aby rozwiązać kilka problemów i wspierać

* Tłumaczenie tekstu komentarza do kodu `rust`
* brak tłumaczenia pól konfiguracyjnych w [vuepressie](https://v2.vuepress.vuejs.org/zh/reference/default-theme/frontmatter.html#prev)
* Buforowanie wiersz po wierszu w celu zmniejszenia kosztów tłumaczenia

Dla następującego tekstu

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/nc10t5.png)

Tłumaczenie działa w następujący sposób

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/CytFEw.png)

Do tłumaczenia potrzebna jest strona [`api key`](https://www.deepl.com/pro-api), należy ją najpierw zamówić. (do otwarcia konta wymagana jest amerykańska karta kredytowa, w razie potrzeby możesz wysłać e-mail na adres `i@rmw.link`, aby uzyskać pomoc w tym zakresie).

Więcej szczegółów można znaleźć w [dokumentacji kodu](https://www.npmjs.com/package/@rmw/deepl-markdown-translate)