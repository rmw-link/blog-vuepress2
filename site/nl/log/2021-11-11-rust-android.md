# Compileren van kiss-ftpd (rust taal programma) voor android set-top box

De busybox komt met een rommelige ftp code, dus ik ga een [kiss-ftpd](https://github.com/moparisthebest/kiss-ftpd) compileren om op de set-top box te gebruiken.

Ten eerste `rustup target add aarch64-linux-android`

Installeer dan de NDK voor Android, ik heb dit gedaan met Android Studio, screenshot hieronder.

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/qcUqsK.png)

Natuurlijk kunt u [de NDK ook rechtstreeks downloaden en uitpakken](https://developer.android.com/ndk/downloads).

In 2021 is de [hoogste versie van de NDK die door rust wordt ondersteund 22.1.7171670](https://github.com/mozilla/rust-android-gradle/issues/75#issuecomment-970179046), dus gebruik die eerst.

Het compilatiescript ziet er tenslotte als volgt uit.

```bash
#include rust-android.sh
```