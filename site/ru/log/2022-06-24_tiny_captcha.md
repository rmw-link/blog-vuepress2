# tiny_captcha : rust легкий генератор captcha, компилируемый в wasm

[Проектная документация](https://docs.rs/tiny_captcha)

Легкий генератор CAPTCHA, опирающийся только на rand и gif, который может быть скомпилирован в wasm.

Основана на [библиотеке CAPTCHA Ивана Тихонова](http://brokestream.com/captcha.html), переписана на [c2rust](https://c2rust.com).

Файл шрифта взят с сайта https://github.com/ITikhonov/captcha/blob/master/font.h и представляет собой ASCII иллюстрацию, сделанную и затем сгенерированную в массив с помощью unfont.

Используйте демо-версию :

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

Выходные данные показаны :

![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/1.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/2.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/3.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/4.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/5.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/6.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/7.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/8.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/9.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/10.gif)