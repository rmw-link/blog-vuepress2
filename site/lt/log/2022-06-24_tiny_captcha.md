# tiny_captcha : rūdžių lengvas captcha generatorius, kompiliuojamas į wasm

[Projekto dokumentai](https://docs.rs/tiny_captcha)

Lengvas CAPTCHA generatorius, paremtas tik rand ir gif, kurį galima kompiliuoti į wasm.

Remiantis [Ivano Tichonovo CAPTCHA biblioteka](http://brokestream.com/captcha.html), perrašyta į [c2rust](https://c2rust.com).

Šrifto failas yra iš https://github.com/ITikhonov/captcha/blob/master/font.h ir yra ASCII meno kūrinys, sukurtas ir tada sugeneruotas į masyvą naudojant "unfont".

Naudokite demonstracinę versiją:

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

Pateikiama išvestis:

![](./gif/1.gif) ![](./gif/2.gif) ![](./gif/3.gif) ![](./gif/4.gif) ![](./gif/5.gif) ![](./gif/6.gif) ![](./gif/7.gif) ![](./gif/8.gif) ![](./gif/9.gif) ![](./gif/10.gif)