# Merkleho strom založený na blake3

[blake3](https://github.com/BLAKE3-team/BLAKE3) je založen na implementaci merkleova stromu, ale vystavené rozhraní neexportuje merkleovy stromy.

[bao](https://github.com/oconnor663/bao) implementuje streamovanou validaci blake3, ale nepodporuje změnu velikosti podkladových [chunků (podporuje větší "skupiny chunků" pro snížení prostorové režie](https://github.com/oconnor663/bao/issues/34) ).

Současná implementace bao spotřebovává 6 % úložného prostoru navíc pro záznam validačních hashů, což je pro server indexující obsah značná režie.

Moje implementace [blake3_merkle](https://github.com/rmw-lib/blake3_merkle), když je `BLOCK_CHUNK` nastavena na 10, vypisuje 32bajtový hash pro každý (1 << 10)*1024 = 1MB, což přidává pouze 0,3‱ další režie.

`./examples/main.rs` Následující :

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

Spusťte `./example.main.sh`a výstup bude vypadat takto

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