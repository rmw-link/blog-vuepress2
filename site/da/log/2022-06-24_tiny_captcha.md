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

![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/1.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/2.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/3.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/4.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/5.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/6.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/7.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/8.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/9.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/10.gif)