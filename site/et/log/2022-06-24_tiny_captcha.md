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

![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/1.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/2.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/3.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/4.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/5.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/6.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/7.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/8.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/9.gif) ![](https://raw.githubusercontent.com/rmw-link/tiny_captcha/master/gif/10.gif)