# tiny_captcha : rust lekki generator captcha, kompilowalny do wasm

[Dokumentacja projektowa](https://docs.rs/tiny_captcha)

Lekki generator CAPTCHA, wykorzystujący tylko rand i gif, który można skompilować do wasm.

Oparta na [bibliotece CAPTCHA Ivana Tikhonova](http://brokestream.com/captcha.html), przepisana w [c2rust](https://c2rust.com).

Plik czcionki pochodzi z witryny https://github.com/ITikhonov/captcha/blob/master/font.h i jest grafiką ASCII, wykonaną, a następnie wygenerowaną do postaci tablicy za pomocą programu unfont.

Użyj wersji demonstracyjnej :

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

Wyświetlane są dane wyjściowe :

![](./gif/1.gif) ![](./gif/2.gif) ![](./gif/3.gif) ![](./gif/4.gif) ![](./gif/5.gif) ![](./gif/6.gif) ![](./gif/7.gif) ![](./gif/8.gif) ![](./gif/9.gif) ![](./gif/10.gif)