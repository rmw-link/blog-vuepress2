# Kompilieren von kiss-ftpd (Rust-Sprachprogramm) für android set-top box

Die busybox kommt mit einem unordentlichen ftp-Code, also werde ich einen [kiss-ftpd](https://github.com/moparisthebest/kiss-ftpd) kompilieren, um ihn auf der Set-Top-Box zu verwenden.

Erstens `rustup target add aarch64-linux-android`

Dann installieren Sie das NDK für Android, ich habe das mit Android Studio gemacht, Screenshot unten.

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/qcUqsK.png)

Natürlich können Sie [das NDK](https://developer.android.com/ndk/downloads) auch [direkt herunterladen und entpacken](https://developer.android.com/ndk/downloads).

Im Jahr 2021 [ist die höchste von Rust unterstützte Version des NDK 22.1.7171670](https://github.com/mozilla/rust-android-gradle/issues/75#issuecomment-970179046), also verwenden Sie diese zuerst.

Das Kompilierungsskript schließlich lautet wie folgt.

```bash
#include rust-android.sh
```