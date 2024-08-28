# Kompilacja kiss-ftpd (program w języku rust) dla android set-top box

busybox jest dostarczany z niechlujnym kodem ftp, więc zamierzam skompilować [kiss-ftpd](https://github.com/moparisthebest/kiss-ftpd), aby używać go na dekoderze.

Po pierwsze `rustup target add aarch64-linux-android`

Następnie zainstaluj pakiet NDK dla systemu Android, ja zrobiłem to za pomocą programu Android Studio, zrzut ekranu poniżej.

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/qcUqsK.png)

Oczywiście można też [pobrać NDK bezpośrednio i rozpakować](https://developer.android.com/ndk/downloads).

W 2021 roku [najwyższą wersją NDK obsługiwaną przez rust jest 22.1.7171670](https://github.com/mozilla/rust-android-gradle/issues/75#issuecomment-970179046), więc należy jej użyć w pierwszej kolejności.

Ostatecznie skrypt kompilacji wygląda następująco.

```bash
#include rust-android.sh
```