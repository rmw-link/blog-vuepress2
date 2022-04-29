# Compilarea kiss-ftpd (program în limba rugină) pentru android set-top box

Busybox vine cu un cod ftp dezordonat, așa că voi compila un [kiss-ftpd](https://github.com/moparisthebest/kiss-ftpd) pentru a-l folosi pe set-top box.

În primul rând `rustup target add aarch64-linux-android`

Apoi instalați NDK pentru Android, am făcut acest lucru cu Android Studio, captura de ecran de mai jos.

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/qcUqsK.png)

Bineînțeles, puteți [descărca direct NDK și](https://developer.android.com/ndk/downloads) îl puteți [despacheta](https://developer.android.com/ndk/downloads).

În 2021, cea [mai mare versiune a NDK-ului acceptat de rust este 22.1.7171670](https://github.com/mozilla/rust-android-gradle/issues/75#issuecomment-970179046), așa că utilizați-o mai întâi.

În cele din urmă, scriptul de compilare este următorul.

```bash
#include rust-android.sh
```