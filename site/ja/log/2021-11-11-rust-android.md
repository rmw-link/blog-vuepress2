# アンドロイドセットトップボックス用kiss-ftpd(Rust言語プログラム)のコンパイル

busyboxには雑なftpのコードが付属しているので、セットトップボックスで使うために [kiss-ftpdを](https://github.com/moparisthebest/kiss-ftpd) コンパイルすることにします。

はじめに `rustup target add aarch64-linux-android`

NDK for Androidをインストールします。

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/qcUqsK.png)

もちろん、 [NDKを直接ダウンロードし、解凍](https://developer.android.com/ndk/downloads)することもできます。

2021年、[rustがサポートするNDKの最高バージョンは22.1.7171670](https://github.com/mozilla/rust-android-gradle/issues/75#issuecomment-970179046) なので、まずそれを使ってください。

最後に、コンパイルスクリプトは以下の通りです。

```bash
#include rust-android.sh
```