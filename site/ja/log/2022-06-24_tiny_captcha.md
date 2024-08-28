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

![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/1.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/2.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/3.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/4.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/5.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/6.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/7.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/8.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/9.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/10.gif)