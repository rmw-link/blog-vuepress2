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

![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/1.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/2.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/3.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/4.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/5.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/6.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/7.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/8.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/9.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/10.gif)