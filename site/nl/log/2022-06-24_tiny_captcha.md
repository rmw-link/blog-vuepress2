# tiny_captcha : roest lichtgewicht captcha generator, compileerbaar naar wasm

[Projectdocumentatie](https://docs.rs/tiny_captcha)

Lichtgewicht CAPTCHA generator, alleen vertrouwend op rand en gif, die kan worden gecompileerd in wasm.

Gebaseerd op [Ivan Tikhonov's CAPTCHA bibliotheek](http://brokestream.com/captcha.html), herschreven in [c2rust](https://c2rust.com).

Het font-bestand is van https://github.com/ITikhonov/captcha/blob/master/font.h en is ASCII artwork, gemaakt en vervolgens gegenereerd in een array met behulp van unfont.

Gebruik de demo :

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

De uitvoer wordt getoond :

![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/1.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/2.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/3.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/4.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/5.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/6.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/7.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/8.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/9.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/10.gif)