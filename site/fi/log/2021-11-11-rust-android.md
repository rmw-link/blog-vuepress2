# Kiss-ftpd:n ( ruosteenkielinen ohjelma ) kääntäminen android-sovittimelle.

busyboxin mukana tulee sotkuinen ftp-koodi, joten aion kääntää [kiss-ftpd:](https://github.com/moparisthebest/kiss-ftpd) n käytettäväksi digiboksilla.

Ensinnäkin `rustup target add aarch64-linux-android`

Asenna sitten Androidin NDK, tein tämän Android Studion avulla, kuvakaappaus alla.

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/qcUqsK.png)

Voit tietenkin myös [ladata NDK:n suoraan ja purkaa](https://developer.android.com/ndk/downloads) sen [pakkauksen](https://developer.android.com/ndk/downloads).

Vuonna 2021 [korkein rustin tukema NDK-versio on 22.1.7171670](https://github.com/mozilla/rust-android-gradle/issues/75#issuecomment-970179046), joten käytä sitä ensin.

Lopuksi käännöskomentosarja on seuraava.

```bash
#include rust-android.sh
```