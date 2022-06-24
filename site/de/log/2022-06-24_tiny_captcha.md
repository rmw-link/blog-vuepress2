# tiny_captcha : rust leichtgewichtiger Captcha-Generator, kompilierbar zu wasm

[Projektdokumentation](https://docs.rs/tiny_captcha)

Leichtgewichtiger CAPTCHA-Generator, der nur auf rand und gif basiert und in wasm kompiliert werden kann.

Basiert auf [Ivan Tikhonovs CAPTCHA-Bibliothek](http://brokestream.com/captcha.html), umgeschrieben in [c2rust](https://c2rust.com).

Die Schriftdatei stammt von https://github.com/ITikhonov/captcha/blob/master/font.h und ist eine ASCII-Grafik, die mit unfont in ein Array generiert wurde.

Verwenden Sie die Demo :

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

Die Ausgabe wird angezeigt:

![](./gif/1.gif) ![](./gif/2.gif) ![](./gif/3.gif) ![](./gif/4.gif) ![](./gif/5.gif) ![](./gif/6.gif) ![](./gif/7.gif) ![](./gif/8.gif) ![](./gif/9.gif) ![](./gif/10.gif)