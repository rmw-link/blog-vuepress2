# tiny_captcha : wasm にコンパイル可能な rust 軽量キャプチャジェネレータ

[プロジェクトドキュメント](https://docs.rs/tiny_captcha)

rand と gif にのみ依存する軽量な CAPTCHA ジェネレータで、wasm にコンパイルすることができます。

[Ivan Tikhonov氏のCAPTCHA](http://brokestream.com/captcha.html) ライブラリをベースに、 [c2rustで](https://c2rust.com) 書き直したものです。

フォントファイルは https://github.com/ITikhonov/captcha/blob/master/font.h のもので、ASCIIアートワークを作成し、unfontを使って配列に生成したものです。

デモをご利用ください。

```rust
use anyhow::Result;
use std::{env::current_exe, fs::File};
use tiny_captcha::gif;

fn main() -> Result<()> {
  for i in 1..=10 {
    let exe = current_exe()?;
    let gif_path = exe.parent().unwrap().join(format!("{}.gif", i));

    let word = gif(&mut File::create(&gif_path)?);
    println!("{} {}", word, gif_path.display());
  }
  Ok(())
}
```

出力は以下の通りです。

![](./gif/1.gif) ![](./gif/2.gif) ![](./gif/3.gif) ![](./gif/4.gif) ![](./gif/5.gif) ![](./gif/6.gif) ![](./gif/7.gif) ![](./gif/8.gif) ![](./gif/9.gif) ![](./gif/10.gif)