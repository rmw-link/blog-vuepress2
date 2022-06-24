# tiny_captcha : gerador de captcha leve de ferrugem, compilável para wasm

[Documentação do projecto](https://docs.rs/tiny_captcha)

Gerador de CAPTCHA leve, que depende apenas de rand e gif, que pode ser compilado em wasm.

Baseado na [biblioteca CAPTCHA de Ivan Tikhonov](http://brokestream.com/captcha.html), reescrita em [c2rust](https://c2rust.com).

O ficheiro da fonte é de https://github.com/ITikhonov/captcha/blob/master/font.h e é uma obra de arte ASCII, feita e depois gerada numa matriz utilizando fontes não-fonte.

Utilize a demonstração :

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

A produção é mostrada :

![](./gif/1.gif) ![](./gif/2.gif) ![](./gif/3.gif) ![](./gif/4.gif) ![](./gif/5.gif) ![](./gif/6.gif) ![](./gif/7.gif) ![](./gif/8.gif) ![](./gif/9.gif) ![](./gif/10.gif)