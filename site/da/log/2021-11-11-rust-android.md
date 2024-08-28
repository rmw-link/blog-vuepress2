# Kompilering af kiss-ftpd ( program på rustsprog ) til android set-top boks

busyboxen leveres med en rodet ftp-kode, så jeg vil kompilere en [kiss-ftpd](https://github.com/moparisthebest/kiss-ftpd) til brug på set-top-boksen.

For det første `rustup target add aarch64-linux-android`

Installer derefter NDK til Android, jeg gjorde det med Android Studio, skærmbillede nedenfor.

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/qcUqsK.png)

Du kan selvfølgelig også [downloade NDK'en direkte og pakke den ud](https://developer.android.com/ndk/downloads).

I 2021 [er den højeste version af NDK'en, der understøttes af rust, 22.1.7171670](https://github.com/mozilla/rust-android-gradle/issues/75#issuecomment-970179046), så brug den først.

Endelig er kompileringsskriften som følger.

```bash
#include rust-android.sh
```