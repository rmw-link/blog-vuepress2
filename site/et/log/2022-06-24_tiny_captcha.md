# tiny_captcha : rooste kergekaaluline captcha generaator, mis on kompileeritav wasm'ile

[Projekti dokumentatsioon](https://docs.rs/tiny_captcha)

Kerge CAPTCHA generaator, mis tugineb ainult randile ja gifile ja mida saab koostada wasm'i.

Põhineb [Ivan Tihhonovi CAPTCHA raamatukogul](http://brokestream.com/captcha.html), mis on ümber kirjutatud [c2rust](https://c2rust.com) 'is.

Kirjatüübifail on pärit aadressilt https://github.com/ITikhonov/captcha/blob/master/font.h ja on ASCII-kujundus, mis on tehtud ja seejärel genereeritud unfonti abil massiiviks.

Kasutage demo :

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

Väljund on näidatud :

![](./gif/1.gif) ![](./gif/2.gif) ![](./gif/3.gif) ![](./gif/4.gif) ![](./gif/5.gif) ![](./gif/6.gif) ![](./gif/7.gif) ![](./gif/8.gif) ![](./gif/9.gif) ![](./gif/10.gif)