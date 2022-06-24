# tiny_captcha : rozsda könnyű captcha generátor, fordítható wasm-be

[Projekt dokumentáció](https://docs.rs/tiny_captcha)

Könnyű CAPTCHA generátor, amely csak a rand és a gif programokra támaszkodik, és wasm-be fordítható.

[Ivan Tikhonov CAPTCHA könyvtárán](http://brokestream.com/captcha.html) alapul, újraírva [c2rust](https://c2rust.com) nyelven.

A betűtípus fájl a https://github.com/ITikhonov/captcha/blob/master/font.h oldalról származik, és ASCII artwork, amelyet az unfont segítségével készítettek, majd generáltak egy tömbbe.

Használja a demót :

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

A kimenet látható :

![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/1.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/2.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/3.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/4.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/5.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/6.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/7.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/8.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/9.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/10.gif)