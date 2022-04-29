# Compilazione di kiss-ftpd (programma in linguaggio rust) per set-top box android

La busybox viene fornita con un codice ftp disordinato, quindi ho intenzione di compilare un [kiss-ftpd](https://github.com/moparisthebest/kiss-ftpd) da usare sul set-top box.

In primo luogo `rustup target add aarch64-linux-android`

Poi installate l'NDK per Android, io l'ho fatto con Android Studio, screenshot qui sotto.

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/qcUqsK.png)

Naturalmente, potete anche [scaricare direttamente l'NDK e scompattarlo](https://developer.android.com/ndk/downloads).

Nel 2021, la [versione più alta dell'NDK supportata da rust è la 22.1.7171670](https://github.com/mozilla/rust-android-gradle/issues/75#issuecomment-970179046), quindi usate prima quella.

Infine, lo script di compilazione è il seguente.

```bash
#include rust-android.sh
```