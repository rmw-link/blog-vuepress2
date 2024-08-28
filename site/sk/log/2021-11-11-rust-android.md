# Kompilácia kiss-ftpd ( program v jazyku rust ) pre android set-top box

Busybox je dodávaný s chaotickým ftp kódom, takže sa chystám skompilovať [kiss-ftpd](https://github.com/moparisthebest/kiss-ftpd) na použitie na set-top boxe.

Najprv `rustup target add aarch64-linux-android`

Potom nainštalujte NDK pre Android, urobil som to pomocou Android Studio, obrázok nižšie.

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/qcUqsK.png)

[NDK si](https://developer.android.com/ndk/downloads) samozrejme môžete [stiahnuť](https://developer.android.com/ndk/downloads) aj [priamo a rozbaliť](https://developer.android.com/ndk/downloads) ho.

V roku 2021 [je najvyššia verzia NDK podporovaná rezom 22.1.7171670](https://github.com/mozilla/rust-android-gradle/issues/75#issuecomment-970179046), preto ju použite ako prvú.

Nakoniec je skript kompilácie nasledovný.

```bash
#include rust-android.sh
```