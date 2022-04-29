# Kompiliranje kiss-ftpd ( rust jezikovni program ) za android set-top box

busybox prihaja z neredno ftp kodo, zato bom sestavil [kiss-ftpd](https://github.com/moparisthebest/kiss-ftpd) za uporabo na set-top boxu.

Najprej `rustup target add aarch64-linux-android`

Nato namestite NDK za Android, to sem storil s programom Android Studio, spodnja slika zaslona.

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/qcUqsK.png)

Seveda lahko [NDK prenesete](https://developer.android.com/ndk/downloads) tudi [neposredno](https://developer.android.com/ndk/downloads) in ga [razpakirate](https://developer.android.com/ndk/downloads).

V letu 2021 [je najvišja različica NDK, ki jo podpira rust, 22.1.7171670](https://github.com/mozilla/rust-android-gradle/issues/75#issuecomment-970179046), zato najprej uporabite to različico.

Skripta za sestavljanje je naslednja.

```bash
#include rust-android.sh
```