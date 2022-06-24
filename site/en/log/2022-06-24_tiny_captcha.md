# tiny_captcha : rust lightweight captcha generator that compiles to wasm

[Project documentation](https://docs.rs/tiny_captcha)

Lightweight CAPTCHA generator, relying only on rand and gif, can be compiled into wasm.

Based on [Ivan Tikhonov's captcha library](http://brokestream.com/captcha.html), rewritten with [c2rust](https://c2rust.com) code conversion.

The font file is from https://github.com/ITikhonov/captcha/blob/master/font.h and is ASCII artwork, make and then use unfont to generate the array.

Use the demo :

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

The output is shown :

![](./gif/1.gif) ![](./gif/2.gif) ![](./gif/3.gif) ![](./gif/4.gif) ![](./gif/5.gif) ![](./gif/6.gif) ![](./gif/7.gif) ![](./gif/8.gif) ![](./gif/9.gif) ![](./gif/10.gif)