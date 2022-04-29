# Компиляция kiss-ftpd (программа на языке rust) для приставки android

busybox поставляется с беспорядочным ftp-кодом, поэтому я собираюсь скомпилировать [kiss-ftpd](https://github.com/moparisthebest/kiss-ftpd) для использования на приставке.

Во-первых, `rustup target add aarch64-linux-android`

Затем установите NDK для Android, я сделал это с помощью Android Studio, скриншот ниже.

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/qcUqsK.png)

Конечно, вы также можете [скачать NDK напрямую и распаковать](https://developer.android.com/ndk/downloads) его.

В 2021 году [самой высокой версией NDK, поддерживаемой rust, является 22.1.7171670](https://github.com/mozilla/rust-android-gradle/issues/75#issuecomment-970179046), поэтому используйте ее в первую очередь.

Наконец, сценарий компиляции выглядит следующим образом.

```bash
#include rust-android.sh
```