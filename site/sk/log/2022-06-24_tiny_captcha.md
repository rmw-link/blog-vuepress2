# tiny_captcha : rust lightweight captcha generator, kompilovateľný do wasm

[Projektová dokumentácia](https://docs.rs/tiny_captcha)

Odľahčený generátor CAPTCHA, ktorý sa spolieha len na rand a gif a ktorý možno skompilovať do wasm.

Založené na [knižnici CAPTCHA od Ivana Tichonova](http://brokestream.com/captcha.html), prepísané v [c2rust](https://c2rust.com).

Súbor písma je z adresy https://github.com/ITikhonov/captcha/blob/master/font.h a je to umelecké dielo ASCII, ktoré sa vytvorilo a potom vygenerovalo do poľa pomocou funkcie unfont.

Použite demo :

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

Výstup je zobrazený :

![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/1.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/2.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/3.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/4.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/5.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/6.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/7.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/8.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/9.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/10.gif)