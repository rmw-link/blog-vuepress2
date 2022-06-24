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

![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/1.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/2.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/3.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/4.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/5.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/6.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/7.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/8.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/9.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/10.gif)