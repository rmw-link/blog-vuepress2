# Kiss-ftpd ( rooste keele programm ) android digiboksi jaoks kompileerimine

Busyboxiga on kaasas räpane ftp-kood, nii et ma kavatsen kompileerida [kiss-ftpd](https://github.com/moparisthebest/kiss-ftpd), mida kasutada digiboksis.

Esiteks `rustup target add aarch64-linux-android`

Seejärel installige NDK for Android, ma tegin seda Android Studio abil, ekraanipilt allpool.

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/qcUqsK.png)

Loomulikult võite [NDK](https://developer.android.com/ndk/downloads) ka [otse alla laadida ja lahti pakkida](https://developer.android.com/ndk/downloads).

Aastal 2021 [on rooste poolt toetatud NDK kõrgeim versioon 22.1.7171670](https://github.com/mozilla/rust-android-gradle/issues/75#issuecomment-970179046), seega kasutage kõigepealt seda.

Lõpuks on kompileerimisskript järgmine.

```bash
#include rust-android.sh
```