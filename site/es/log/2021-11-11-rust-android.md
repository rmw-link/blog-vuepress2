# Compilación de kiss-ftpd ( programa en lenguaje rust ) para set-top box android

El busybox viene con un código ftp desordenado, así que voy a compilar un [kiss-ftpd](https://github.com/moparisthebest/kiss-ftpd) para usarlo en el set-top box.

En primer lugar `rustup target add aarch64-linux-android`

Luego instala el NDK para Android, yo lo hice con Android Studio, captura de pantalla abajo.

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/qcUqsK.png)

Por supuesto, también puedes [descargar el NDK directamente y descomprimirlo](https://developer.android.com/ndk/downloads).

En 2021, la [versión más alta del NDK soportada por rust es la 22.1.7171670](https://github.com/mozilla/rust-android-gradle/issues/75#issuecomment-970179046), así que usa esa primero.

Por último, el script de compilación es el siguiente.

```bash
#include rust-android.sh
```