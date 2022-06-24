# tiny_captcha : ruosteessa kevyt captcha generaattori, käännettävissä wasm:ksi.

[Hankeasiakirjat](https://docs.rs/tiny_captcha)

Kevyt CAPTCHA-generaattori, joka perustuu vain randiin ja gifiin ja joka voidaan kääntää wasm:ksi.

Perustuu [Ivan Tikhonovin CAPTCHA-kirjastoon](http://brokestream.com/captcha.html), joka on kirjoitettu uudelleen [c2rust-kielellä](https://c2rust.com).

Fonttitiedosto on peräisin osoitteesta https://github.com/ITikhonov/captcha/blob/master/font.h, ja se on ASCII-taideteos, joka on tehty ja sitten luotu arrayksi unfont-ohjelmalla.

Käytä demoa :

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

Tulos näkyy :

![](./gif/1.gif) ![](./gif/2.gif) ![](./gif/3.gif) ![](./gif/4.gif) ![](./gif/5.gif) ![](./gif/6.gif) ![](./gif/7.gif) ![](./gif/8.gif) ![](./gif/9.gif) ![](./gif/10.gif)