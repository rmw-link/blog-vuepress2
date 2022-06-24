# tiny_captcha : générateur de captcha léger de type rust, compilable en wasm

[Documentation du projet](https://docs.rs/tiny_captcha)

Générateur de CAPTCHA léger, reposant uniquement sur rand et gif, qui peut être compilé dans wasm.

Basé sur la [bibliothèque CAPTCHA d'Ivan Tikhonov](http://brokestream.com/captcha.html), réécrit en [c2rust](https://c2rust.com).

Le fichier de police provient de https://github.com/ITikhonov/captcha/blob/master/font.h. Il s'agit d'un travail artistique ASCII, réalisé puis généré dans un tableau à l'aide de unfont.

Utilisez la démo :

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

La sortie est indiquée :

![](./gif/1.gif) ![](./gif/2.gif) ![](./gif/3.gif) ![](./gif/4.gif) ![](./gif/5.gif) ![](./gif/6.gif) ![](./gif/7.gif) ![](./gif/8.gif) ![](./gif/9.gif) ![](./gif/10.gif)