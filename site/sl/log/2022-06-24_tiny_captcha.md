# tiny_captcha : rust lightweight captcha generator, ki ga je mogoče sestaviti v wasm

[Projektna dokumentacija](https://docs.rs/tiny_captcha)

Lahkoten generator CAPTCHA, ki temelji le na randu in gifu in ga je mogoče sestaviti v wasm.

Temelji na [knjižnici CAPTCHA Ivana Tihonova](http://brokestream.com/captcha.html), ki je na novo napisana v [c2rust](https://c2rust.com).

Datoteka s pisavo je iz https://github.com/ITikhonov/captcha/blob/master/font.h in je umetniško delo ASCII, ki je bilo izdelano in nato ustvarjeno v polje z uporabo programa unfont.

Uporabite demo :

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

Izhod je prikazan:

![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/1.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/2.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/3.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/4.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/5.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/6.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/7.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/8.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/9.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/10.gif)