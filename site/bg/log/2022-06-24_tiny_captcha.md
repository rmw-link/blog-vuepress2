# tiny_captcha : rust lightweight captcha generator, compilable to wasm

[Документация на проекта](https://docs.rs/tiny_captcha)

Олекотен генератор на CAPTCHA, разчитащ само на rand и gif, който може да бъде компилиран в wasm.

Базирана на [библиотеката CAPTCHA на Иван Тихонов](http://brokestream.com/captcha.html), пренаписана на [c2rust](https://c2rust.com).

Файлът с шрифта е от https://github.com/ITikhonov/captcha/blob/master/font.h и представлява ASCII произведение, направено и след това генерирано в масив с помощта на unfont.

Използвайте демо версията :

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

Изходът е показан :

![](./gif/1.gif) ![](./gif/2.gif) ![](./gif/3.gif) ![](./gif/4.gif) ![](./gif/5.gif) ![](./gif/6.gif) ![](./gif/7.gif) ![](./gif/8.gif) ![](./gif/9.gif) ![](./gif/10.gif)