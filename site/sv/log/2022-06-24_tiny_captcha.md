# tiny_captcha : Rost lättviktig captcha-generator, kompilerbar till wasm

[Projektdokumentation](https://docs.rs/tiny_captcha)

Lättviktig CAPTCHA-generator som endast använder rand och gif och som kan kompileras till wasm.

Baserat på [Ivan Tikhonovs CAPTCHA-bibliotek](http://brokestream.com/captcha.html), omskrivet i [c2rust](https://c2rust.com).

Typsnittsfilen kommer från https://github.com/ITikhonov/captcha/blob/master/font.h och är en ASCII-bild, som skapats och sedan genererats till en array med hjälp av unfont.

Använd demotypen :

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

Utmatningen visas :

![](./gif/1.gif) ![](./gif/2.gif) ![](./gif/3.gif) ![](./gif/4.gif) ![](./gif/5.gif) ![](./gif/6.gif) ![](./gif/7.gif) ![](./gif/8.gif) ![](./gif/9.gif) ![](./gif/10.gif)