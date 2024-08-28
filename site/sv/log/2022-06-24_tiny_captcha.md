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

![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/1.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/2.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/3.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/4.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/5.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/6.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/7.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/8.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/9.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/10.gif)