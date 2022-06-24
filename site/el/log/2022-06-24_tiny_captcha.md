# tiny_captcha : ελαφριά γεννήτρια captcha, μεταγλώττιση σε wasm

[Τεκμηρίωση έργου](https://docs.rs/tiny_captcha)

Ελαφριά γεννήτρια CAPTCHA, η οποία βασίζεται μόνο στα rand και gif και μπορεί να μεταγλωττιστεί σε wasm.

Βασισμένο [στη βιβλιοθήκη CAPTCHA του Ivan Tikhonov](http://brokestream.com/captcha.html), ξαναγραμμένο σε [c2rust](https://c2rust.com).

Το αρχείο γραμματοσειράς προέρχεται από το https://github.com/ITikhonov/captcha/blob/master/font.h και είναι έργο τέχνης ASCII, το οποίο δημιουργήθηκε και στη συνέχεια δημιουργήθηκε σε έναν πίνακα με τη χρήση του unfont.

Χρησιμοποιήστε το demo :

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

Η έξοδος εμφανίζεται :

![](./gif/1.gif) ![](./gif/2.gif) ![](./gif/3.gif) ![](./gif/4.gif) ![](./gif/5.gif) ![](./gif/6.gif) ![](./gif/7.gif) ![](./gif/8.gif) ![](./gif/9.gif) ![](./gif/10.gif)