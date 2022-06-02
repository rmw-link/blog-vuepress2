# Merkle puu põhineb blake3

[blake3](https://github.com/BLAKE3-team/BLAKE3) põhineb merkle-puu rakendamisel, kuid avalikustatud liides ei ekspordi merkle-puid.

[bao](https://github.com/oconnor663/bao) rakendab voogesituse blake3 valideerimist, kuid ei [toeta](https://github.com/oconnor663/bao/issues/34) aluseks olevate [tükkide](https://github.com/oconnor663/bao/issues/34) suuruse muutmist [(toetab suuremaid "tükkide gruppe", et vähendada ruumi koormust](https://github.com/oconnor663/bao/issues/34) ).

Praegune bao rakendamine tarbib 6% täiendavat salvestusruumi valideerimishaššide salvestamiseks, mis on sisu indekseerimisserveri jaoks märkimisväärne lisakulu.

Minu [blake3_merkle](https://github.com/rmw-lib/blake3_merkle) rakendamine, kui `BLOCK_CHUNK` on seatud 10, väljastab 32baidise hashi iga (1 << 10)*1024 = 1MB kohta, lisades ainult 0,3‱ lisakulu.

`./examples/main.rs` Järgnevalt :

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

Käivita `./example.main.sh`ja väljund näeb välja selline

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