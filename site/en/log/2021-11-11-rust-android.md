# Compile kiss-ftpd ( rust language program ) for android set-top box

The busybox comes with a messy ftp code, so I want to compile a [kiss-ftpd](https://github.com/moparisthebest/kiss-ftpd) to be used on the set-top box.

First, the `rustup target add aarch64-linux-android`

Then install the Android NDK, I used Android Studio to install it, screenshot below.

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/qcUqsK.png)

Of course, you can also [download the NDK directly to unpack](https://developer.android.com/ndk/downloads) it.

In 2021, [the highest version of NDK supported by rust is 22.1.7171670](https://github.com/mozilla/rust-android-gradle/issues/75#issuecomment-970179046), so use this one first.

Finally, the compilation script is as follows.

```bash
#include rust-android.sh
```