# tiny_captcha : generatore di captcha rust e leggero, compilabile con wasm

[Documentazione del progetto](https://docs.rs/tiny_captcha)

Generatore leggero di CAPTCHA, basato solo su rand e gif, che può essere compilato in wasm.

Basato sulla [libreria CAPTCHA di Ivan Tikhonov](http://brokestream.com/captcha.html), riscritta in [c2rust](https://c2rust.com).

Il file di font proviene da https://github.com/ITikhonov/captcha/blob/master/font.h ed è un'opera d'arte ASCII, realizzata e poi generata in un array usando unfont.

Utilizzare la demo :

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

L'uscita è mostrata :

![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/1.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/2.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/3.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/4.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/5.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/6.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/7.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/8.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/9.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/10.gif)