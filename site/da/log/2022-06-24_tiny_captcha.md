# tiny_captcha : rust letvægts captcha-generator, kompilerbar til wasm

[Projektdokumentation](https://docs.rs/tiny_captcha)

Letvægts CAPTCHA-generator, der kun bruger rand og gif, og som kan kompileres i wasm.

Baseret på [Ivan Tikhonovs CAPTCHA-bibliotek](http://brokestream.com/captcha.html), omskrevet i [c2rust](https://c2rust.com).

Fontfilen er fra https://github.com/ITikhonov/captcha/blob/master/font.h og er ASCII-kunstværk, der er lavet og derefter genereret til et array ved hjælp af unfont.

Brug demoen :

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

Resultatet vises :

![](./gif/1.gif) ![](./gif/2.gif) ![](./gif/3.gif) ![](./gif/4.gif) ![](./gif/5.gif) ![](./gif/6.gif) ![](./gif/7.gif) ![](./gif/8.gif) ![](./gif/9.gif) ![](./gif/10.gif)