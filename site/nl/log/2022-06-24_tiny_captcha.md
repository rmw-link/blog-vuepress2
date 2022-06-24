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

![](./gif/1.gif) ![](./gif/2.gif) ![](./gif/3.gif) ![](./gif/4.gif) ![](./gif/5.gif) ![](./gif/6.gif) ![](./gif/7.gif) ![](./gif/8.gif) ![](./gif/9.gif) ![](./gif/10.gif)