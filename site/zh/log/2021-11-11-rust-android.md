# 编译 kiss-ftpd ( rust 语言的程序 ) 给 android 机顶盒使用

busybox 自带的 ftp 中文乱码，打算编译一个 [kiss-ftpd](https://github.com/moparisthebest/kiss-ftpd) 传到机顶盒上使用。

首先， `rustup target add aarch64-linux-android`

然后安装安卓的 NDK，我是用 Android Studio 装的，截图如下。

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/qcUqsK.png)

当然也可以 [直接去下载 NDK 解包](https://developer.android.com/ndk/downloads)。

2021 年，[rust 支持的 NDK 最高版本是 22.1.7171670](https://github.com/mozilla/rust-android-gradle/issues/75#issuecomment-970179046) ，先用这个。

最后，编译脚本如下。

```bash
#include rust-android.sh
```