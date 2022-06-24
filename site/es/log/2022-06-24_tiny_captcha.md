# tiny_captcha : generador de captchas ligero, compilable en wasm

[Documentación del proyecto](https://docs.rs/tiny_captcha)

Generador de CAPTCHA ligero, que depende sólo de rand y gif, y que puede ser compilado en wasm.

Basado en [la biblioteca CAPTCHA de Ivan Tikhonov](http://brokestream.com/captcha.html), reescrito en [c2rust](https://c2rust.com).

El archivo de fuentes es de https://github.com/ITikhonov/captcha/blob/master/font.h y es una obra de arte ASCII, hecha y luego generada en una matriz usando unfont.

Utiliza la demo :

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

La salida se muestra :

![](./gif/1.gif) ![](./gif/2.gif) ![](./gif/3.gif) ![](./gif/4.gif) ![](./gif/5.gif) ![](./gif/6.gif) ![](./gif/7.gif) ![](./gif/8.gif) ![](./gif/9.gif) ![](./gif/10.gif)