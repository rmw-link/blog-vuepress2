# Kompiliuoti kiss-ftpd ( rūdžių kalbos programa ) android set-top box

Į busybox ateina su netvarkinga ftp kodas, todėl aš ketinu parengti [kiss-ftpd](https://github.com/moparisthebest/kiss-ftpd) naudoti televizoriaus priedėlyje.

Pirmiausia `rustup target add aarch64-linux-android`

Tada įdiekite "Android" NDK, aš tai padariau naudodamasis "Android Studio", ekrano nuotrauka pateikta toliau.

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/qcUqsK.png)

Žinoma, taip pat galite [tiesiogiai atsisiųsti NDK ir](https://developer.android.com/ndk/downloads) jį [išpakuoti](https://developer.android.com/ndk/downloads).

2021 m. [aukščiausia NDK versija, palaikoma rust, yra 22.1.7171670](https://github.com/mozilla/rust-android-gradle/issues/75#issuecomment-970179046), todėl pirmiausia naudokite ją.

Galiausiai, kompiliavimo scenarijus yra toks.

```bash
#include rust-android.sh
```