# Merklio medis pagal blake3

[blake3](https://github.com/BLAKE3-team/BLAKE3) remiasi merklio medžio įgyvendinimu, tačiau atveriama sąsaja neeksportuoja merklio medžių.

[bao](https://github.com/oconnor663/bao) įgyvendina srautinį blake3 patvirtinimą, tačiau nepalaiko pagrindinių [gabalėlių](https://github.com/oconnor663/bao/issues/34) dydžio keitimo [(palaiko didesnes "gabalėlių grupes", kad sumažėtų vietos sąnaudos](https://github.com/oconnor663/bao/issues/34) ).

Dabartinis bao įgyvendinimas naudoja 6 % papildomos saugojimo vietos, kad įrašytų patvirtinimo hashes, o tai yra didelė turinio indeksavimo serverio pridėtinė našta.

Mano įgyvendinta [blake3_merkle](https://github.com/rmw-lib/blake3_merkle), kai `BLOCK_CHUNK` yra 10, išveda 32 baitų hash kas (1 << 10)*1024 = 1 MB, pridėdama tik 0,3‱ papildomų pridėtinių išlaidų.

`./examples/main.rs` Taip:

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

Paleiskite `./example.main.sh`ir išvestis atrodys taip

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