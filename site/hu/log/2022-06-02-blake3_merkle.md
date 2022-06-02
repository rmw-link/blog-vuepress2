# Merkle-fa a blake3 alapján

A [blake3](https://github.com/BLAKE3-team/BLAKE3) alapja egy merkle-fa, de a megjelenített interfész nem exportálja a merkle-fát.

A [bao](https://github.com/oconnor663/bao) megvalósítja a blake3 streaming érvényesítést, de nem tudja átméretezni az alapul szolgáló [darabokat](https://github.com/oconnor663/bao/issues/34) (lásd: [nagyobb "darabcsoportok" támogatása a kisebb helyigény érdekében](https://github.com/oconnor663/bao/issues/34) ).

Ez azt jelenti, hogy a bao 6% extra tárhelyet igényel a merkle-fa rögzítéséhez, ami jelentős többletköltséget jelent egy elosztott tartalomindex esetében.

Ezért a [blake3_merkle-t](https://github.com/rmw-lib/blake3_merkle) úgy implementáltam, hogy 1 MB tartalomra 32 bájt hash-t exportáljon, 0,3‱ további tárolási többletköltséggel.

`./examples/main.rs` Az alábbiak szerint:

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

A `./example.main.sh`futtatásával a kimenet így fog kinézni

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