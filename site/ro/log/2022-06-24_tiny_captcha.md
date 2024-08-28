# tiny_captcha : generator de captcha ușor, compilabil în wasm

[Documentația proiectului](https://docs.rs/tiny_captcha)

Generator CAPTCHA ușor, bazat doar pe rand și gif, care poate fi compilat în wasm.

Bazat pe [biblioteca CAPTCHA a lui Ivan Tikhonov](http://brokestream.com/captcha.html), rescrisă în [c2rust](https://c2rust.com).

Fișierul fontului este de la https://github.com/ITikhonov/captcha/blob/master/font.h și este o lucrare ASCII, realizată și apoi generată într-o matrice folosind unfont.

Utilizați demonstrația :

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

Ieșirea este prezentată :

![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/1.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/2.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/3.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/4.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/5.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/6.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/7.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/8.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/9.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/10.gif)