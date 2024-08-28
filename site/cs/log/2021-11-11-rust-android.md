# Kompilace kiss-ftpd ( program v jazyce rust ) pro set-top box s Androidem

busybox je dodáván s chaotickým ftp kódem, takže se chystám zkompilovat [kiss-ftpd](https://github.com/moparisthebest/kiss-ftpd) pro použití na set-top boxu.

Nejprve `rustup target add aarch64-linux-android`

Poté nainstalujte NDK pro Android, já jsem to udělal pomocí Android Studia, obrázek níže.

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/qcUqsK.png)

[NDK si](https://developer.android.com/ndk/downloads) samozřejmě můžete [stáhnout přímo a rozbalit](https://developer.android.com/ndk/downloads).

V roce 2021 [je nejvyšší verze NDK podporovaná rustem 22.1.7171670](https://github.com/mozilla/rust-android-gradle/issues/75#issuecomment-970179046), takže ji použijte jako první.

Nakonec je kompilační skript následující.

```bash
#include rust-android.sh
```