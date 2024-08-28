# kompilēšana kiss-ftpd ( rūsas valodas programma ) android set-top box

busybox nāk ar haotisku ftp kodu, tāpēc es esmu gatavojas apkopot [kiss-ftpd](https://github.com/moparisthebest/kiss-ftpd) izmantot uz televizora pierīces.

Vispirms `rustup target add aarch64-linux-android`

Pēc tam instalējiet Android NDK, es to izdarīju ar Android Studio, zemāk redzamais ekrānšāviņš.

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/qcUqsK.png)

Protams, varat arī [lejupielādēt NDK tieši un](https://developer.android.com/ndk/downloads) to [atpakot](https://developer.android.com/ndk/downloads).

2021. gadā [rust atbalstītā augstākā NDK versija ir 22.1.7171670](https://github.com/mozilla/rust-android-gradle/issues/75#issuecomment-970179046), tāpēc vispirms izmantojiet to.

Visbeidzot, kompilēšanas skripts ir šāds.

```bash
#include rust-android.sh
```