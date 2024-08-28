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

![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/1.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/2.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/3.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/4.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/5.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/6.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/7.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/8.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/9.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/10.gif)