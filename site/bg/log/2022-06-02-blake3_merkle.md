# Дърво на Меркъл, базирано на blake3

[blake3](https://github.com/BLAKE3-team/BLAKE3) се основава на дърво на Меркъл, но изложеният интерфейс не експортира дървото на Меркъл.

[bao](https://github.com/oconnor663/bao) реализира поточно валидиране на blake3, но не може да променя размера на основните [парчета](https://github.com/oconnor663/bao/issues/34) (вж. [поддръжка на по-големи "групи от парчета" за намаляване на преразхода на пространство](https://github.com/oconnor663/bao/issues/34) ).

Това означава, че bao изразходва допълнително 6 % от пространството за съхранение, за да запише дървото на Меркъл, което е значителен преразход за разпределен индекс на съдържанието.

Затова имплементирах [blake3_merkle](https://github.com/rmw-lib/blake3_merkle), за да експортира 32 байта хеш за 1 MB съдържание, с допълнителни разходи за съхранение от 0,3‱.

Дървото на Меркъл може да генерира хешове, съответстващи на blake3.

Когато съдържанието е по-малко или равно на 1 MB, дървото на Меркъл има само един възел и хешът на този възел е равен на хеша на blake3.

`./examples/main.rs` Както следва :

```rust
use blake3_merkle::Merkle;

use std::{env, error::Error, fs::File, io::copy};

fn main() -> Result<(), Box<dyn Error>> {
  let fpath = env::current_dir()?.join("test.pdf");

  let mut blake3 = blake3::Hasher::new();
  copy(&mut File::open(&fpath)?, &mut blake3)?;

  let mut merkle = Merkle::new();
  copy(&mut File::open(&fpath)?, &mut merkle)?;
  merkle.finalize();
  dbg!(&merkle.li);
  dbg!(merkle.blake3());
  dbg!(blake3.finalize());
  Ok(())
}
```

Стартирайте `./example.main.sh`и изходът ще изглежда така

```
[examples/main.rs:14] &merkle.li = [
    HashDepth {
        hash: Hash(
            "eb896f431b7ff8acb4749b54981d461359a01ded0261fa0da856dd28bf29d3b3",
        ),
        depth: 10,
    },
    HashDepth {
        hash: Hash(
            "4a84cc85f03f47a7c32755f8d9d81c5d3f3e04548ee8129fd480cb71c7dbc5b4",
        ),
        depth: 10,
    },
    HashDepth {
        hash: Hash(
            "fbfe78e550b355cb6775e324c4fed7eb987084b115dca599aaf40056bfb031c3",
        ),
        depth: 10,
    },
    HashDepth {
        hash: Hash(
            "392878c3bdc9c315d6cc8a1721d8cd0a39e49ac8716f4cb8cdf6cf83fbb666f5",
        ),
        depth: 6,
    },
]
[examples/main.rs:15] merkle.blake3() = Hash(
    "74a79d0bc37dcac64c493e872252f19e8bdb32dee306481a6827fa037b378c76",
)
[examples/main.rs:16] blake3.finalize() = Hash(
    "74a79d0bc37dcac64c493e872252f19e8bdb32dee306481a6827fa037b378c76",
)
```