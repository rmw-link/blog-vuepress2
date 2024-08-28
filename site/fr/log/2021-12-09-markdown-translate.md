# outils de traduction markdown

Les outils de traduction markdown disponibles sur le marché sont problématiques et ne fonctionnent pas bien.

Par exemple, si vous utilisez [menthays/markdown-translator](https://github.com/menthays/markdown-translator) pour traduire du texte markdown, il traduit

`对 [libmdbx](https://github.com/erthink/libmdbx) 的 rust 封装`

en

`Right [libmdbx](https://github.com/erthink/libmdbx) The rust package of`La raison en est que cela divise le texte en

La raison en est qu'il divise le texte en `{ text: '对 ' },{ text: 'libmdbx' },{ text: ' 的 rust 封装' }`pour le traduire séparément.

L'utilisation de quelque chose d'autre, comme [bilingue](https://github.com/zjp-CN/bilingual/issues/22), ne permet pas de conserver le style du lien.

J'ai écrit `@rmw/deepl-markdown-translate` pour résoudre un certain nombre de problèmes et pour supporter

* Traduction du texte de commentaire du code `rust`
* non traduction des champs de configuration dans [vuepress](https://v2.vuepress.vuejs.org/zh/reference/default-theme/frontmatter.html#prev)
* Mise en cache ligne par ligne pour économiser les coûts de traduction

Pour le texte suivant

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/nc10t5.png)

La traduction fonctionne comme suit

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/CytFEw.png)

La traduction nécessite le [site `api key` de deepl,](https://www.deepl.com/pro-api) veuillez en faire la demande au préalable. (Une carte de crédit américaine est nécessaire pour l'ouverture, vous pouvez envoyer un courriel à `i@rmw.link` pour vous aider à le faire si vous en avez besoin).

Voir la [documentation du code](https://www.npmjs.com/package/@rmw/deepl-markdown-translate) pour plus de détails