# Merkle tree based on blake3

[blake3](https://github.com/BLAKE3-team/BLAKE3) is based on the merkle tree implementation, but the exposed interface does not export the merkle tree.

[bao](https://github.com/oconnor663/bao) implements streaming blake3 verification, but does not [support](https://github.com/oconnor663/bao/issues/34) resizing the underlying [chunks (support larger "chunk groups" for reduced space overhead](https://github.com/oconnor663/bao/issues/34) ).

The current implementation of bao consumes 6% extra storage space to record validation hashes, which is a significant overhead for a content index server.

My implementation of [blake3_merkle](https://github.com/rmw-lib/blake3_merkle), when `BLOCK_CHUNK` is set to 10, outputs a 32-byte hash for every (1 << 10)*1024 = 1MB, adding only 0.3‱ of additional overhead.

`./examples/main.rs` As follows :

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

Run `./example.main.sh`and the output is as follows

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