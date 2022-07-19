# εργαλεία μετάφρασης markdown

Τα εργαλεία μετάφρασης markdown που κυκλοφορούν στην αγορά είναι προβληματικά και δεν λειτουργούν καλά.

Για παράδειγμα, αν χρησιμοποιείτε [το menthays/markdown-translator](https://github.com/menthays/markdown-translator) για να μεταφράσετε κείμενο markdown, μεταφράζει

`对 [libmdbx](https://github.com/erthink/libmdbx) 的 rust 封装`

στο

`Right [libmdbx](https://github.com/erthink/libmdbx) The rust package of`Ο λόγος για αυτό είναι ότι χωρίζει το κείμενο σε

Ο λόγος για αυτό είναι ότι χωρίζει το κείμενο σε `{ text: '对 ' },{ text: 'libmdbx' },{ text: ' 的 rust 封装' }`για να το μεταφράσει ξεχωριστά.

Χρησιμοποιώντας κάτι άλλο, όπως [δίγλωσσο](https://github.com/zjp-CN/bilingual/issues/22), δεν διατηρείται το στυλ του συνδέσμου.

Έγραψα το `@rmw/deepl-markdown-translate` για να λύσω μια σειρά από προβλήματα και να υποστηρίξω

* Μετάφραση του κειμένου σχολιασμού του κώδικα `rust`
* δεν μεταφράζει τα πεδία διαμόρφωσης στο [vuepress](https://v2.vuepress.vuejs.org/zh/reference/default-theme/frontmatter.html#prev)
* Προσωρινή αποθήκευση δεδομένων γραμμή προς γραμμή για εξοικονόμηση κόστους μετάφρασης

Για το ακόλουθο κείμενο

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/nc10t5.png)

Η μετάφραση λειτουργεί ως εξής

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/CytFEw.png)

Η μετάφραση απαιτεί το [`api key`](https://www.deepl.com/pro-api) του deepl, παρακαλούμε ζητήστε το πρώτα. (Για το άνοιγμα απαιτείται πιστωτική κάρτα των ΗΠΑ, μπορείτε να στείλετε email στο `i@rmw.link` για να σας βοηθήσει με αυτό αν το χρειάζεστε).

Δείτε [την τεκμηρίωση του κώδικα](https://www.npmjs.com/package/@rmw/deepl-markdown-translate) για περισσότερες λεπτομέρειες