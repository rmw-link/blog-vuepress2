# tiny_captcha : rust lightweight captcha generator, kompilējams uz wasm

[Projekta dokumentācija](https://docs.rs/tiny_captcha)

Viegls CAPTCHA ģenerators, kas balstās tikai uz rand un gif, ko var kompilēt wasm.

Pamatojoties uz [Ivana Tihonova CAPTCHA bibliotēku](http://brokestream.com/captcha.html), pārrakstīta [c2rust](https://c2rust.com).

Šrifta fails ir no https://github.com/ITikhonov/captcha/blob/master/font.h, un tas ir ASCII mākslas darbs, kas izveidots un pēc tam ģenerēts masīvā, izmantojot unfont.

Izmantojiet demo versiju :

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

Tiek parādīta izeja:

![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/1.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/2.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/3.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/4.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/5.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/6.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/7.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/8.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/9.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/10.gif)