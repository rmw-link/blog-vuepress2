# Compilation de kiss-ftpd (programme en langage rust) pour le set-top box android

La busybox est livrée avec un code ftp désordonné, je vais donc compiler un [kiss-ftpd](https://github.com/moparisthebest/kiss-ftpd) à utiliser sur la set-top box.

Tout d'abord `rustup target add aarch64-linux-android`

Ensuite, installez le NDK pour Android, je l'ai fait avec Android Studio, capture d'écran ci-dessous.

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/qcUqsK.png)

Bien entendu, vous pouvez également [télécharger directement le NDK et](https://developer.android.com/ndk/downloads) le [décompresser](https://developer.android.com/ndk/downloads).

En 2021, la [plus haute version du NDK supportée par rust est 22.1.7171670](https://github.com/mozilla/rust-android-gradle/issues/75#issuecomment-970179046), donc utilisez-la en premier.

Enfin, le script de compilation est le suivant.

```bash
#include rust-android.sh
```