# Компилиране на kiss-ftpd ( програма на езика на ръждата ) за Android set-top box

busybox идва с разхвърлян ftp код, така че ще компилирам [kiss-ftpd](https://github.com/moparisthebest/kiss-ftpd), за да го използвам на декодера.

На първо място `rustup target add aarch64-linux-android`

След това инсталирайте NDK за Android, аз направих това с Android Studio, снимка по-долу.

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/qcUqsK.png)

Разбира се, можете също така да [изтеглите NDK директно и](https://developer.android.com/ndk/downloads) да го [разопаковате](https://developer.android.com/ndk/downloads).

В 2021 г. [най-високата версия на NDK, поддържана от rust, е 22.1.7171670](https://github.com/mozilla/rust-android-gradle/issues/75#issuecomment-970179046), така че използвайте първо нея.

Накрая, скриптът за компилиране е следният.

```bash
#include rust-android.sh
```