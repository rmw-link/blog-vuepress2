# Kiss-ftpd ( rozsda nyelvi program ) fordítása android set-top boxhoz

A busybox egy kusza ftp kóddal érkezik, ezért összeállítok egy [kiss-ftpd-t](https://github.com/moparisthebest/kiss-ftpd), hogy a set-top boxon használhassam.

Először is `rustup target add aarch64-linux-android`

Ezután telepítse az NDK for Androidot, én ezt az Android Studio segítségével tettem, alábbi képernyőkép.

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/qcUqsK.png)

Természetesen az [NDK-t közvetlenül is letöltheti és kicsomagolhatja.](https://developer.android.com/ndk/downloads)

2021-ben a [rust által támogatott NDK legmagasabb verziója a 22.1.7171670](https://github.com/mozilla/rust-android-gradle/issues/75#issuecomment-970179046), ezért először ezt használd.

Végül a fordítási szkript a következő.

```bash
#include rust-android.sh
```