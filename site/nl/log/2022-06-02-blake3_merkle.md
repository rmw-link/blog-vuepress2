# Merkleboom gebaseerd op blake3

[blake3](https://github.com/BLAKE3-team/BLAKE3) is gebaseerd op een merkle tree, maar de blootgelegde interface exporteert de merkle tree niet.

[bao](https://github.com/oconnor663/bao) implementeert blake3 streaming validatie, maar kan de grootte van de onderliggende [chunks](https://github.com/oconnor663/bao/issues/34) niet wijzigen (zie [ondersteuning van grotere "chunk groups" voor minder ruimte-overhead](https://github.com/oconnor663/bao/issues/34) ).

Dit betekent dat bao 6% extra opslagruimte nodig heeft om de merkle tree op te slaan, wat een aanzienlijke overhead is voor een gedistribueerde inhoudsindex.

Dus heb ik [blake3_merkle](https://github.com/rmw-lib/blake3_merkle) geïmplementeerd om 32 bytes hash af te leiden per 1MB inhoud met een extra opslag-overhead van 0.3‱.

De merkle boom genereert hashes die consistent zijn met blake3.

Wanneer de inhoud kleiner is dan of gelijk aan 1MB, heeft de merkle tree slechts één knoop en de hash van deze knoop is gelijk aan de hash van blake3.

`./examples/main.rs` Als volgt :

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

Start `./example.main.sh`en de output is als volgt

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