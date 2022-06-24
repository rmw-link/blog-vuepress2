# tiny_captcha : rust lightweight captcha generator, kompilovatelný do wasm

[Projektová dokumentace](https://docs.rs/tiny_captcha)

Lehký generátor CAPTCHA, který se spoléhá pouze na rand a gif a který lze zkompilovat do wasm.

Založeno na [knihovně CAPTCHA Ivana Tichonova](http://brokestream.com/captcha.html), přepsané v [c2rust](https://c2rust.com).

Soubor s písmem pochází z adresy https://github.com/ITikhonov/captcha/blob/master/font.h a jedná se o kresbu ASCII, která byla vytvořena a následně vygenerována do pole pomocí nástroje unfont.

Použijte ukázku :

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

Výstup je zobrazen :

![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/1.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/2.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/3.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/4.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/5.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/6.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/7.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/8.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/9.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/10.gif)