# Kompilering av kiss-ftpd (program i rost) för android set-top box

busyboxen levereras med en rörig ftp-kod, så jag ska kompilera en [kiss-ftpd](https://github.com/moparisthebest/kiss-ftpd) för att använda den på set-top-boxen.

För det första `rustup target add aarch64-linux-android`

Installera sedan NDK för Android, jag gjorde detta med Android Studio, skärmdump nedan.

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/qcUqsK.png)

Du kan naturligtvis också [ladda ner NDK direkt och packa upp](https://developer.android.com/ndk/downloads) den.

År 2021 [är den högsta versionen av NDK som stöds av rust 22.1.7171670](https://github.com/mozilla/rust-android-gradle/issues/75#issuecomment-970179046), så använd den först.

Slutligen är kompileringsskriptet följande.

```bash
#include rust-android.sh
```