# blake3をベースにしたメルクル木

[blake3は](https://github.com/BLAKE3-team/BLAKE3) merkle treeの実装をベースにしていますが、公開されているインターフェースはmerkle treeをエクスポートするものではありません。

[baoは](https://github.com/oconnor663/bao) ストリーミングBlake3検証を実装していますが、基礎となる [チャンクの](https://github.com/oconnor663/bao/issues/34) サイズ変更は [サポートしていません（容量のオーバーヘッドを減らすために、より大きな「チャンクグループ」をサポート](https://github.com/oconnor663/bao/issues/34) します）。

現在のbaoの実装では、検証用ハッシュを記録するために6%の余分なストレージスペースを消費しており、これはコンテンツのインデックス作成サーバーにとって大きなオーバーヘッドとなっています。

私の実装した [blake3_merkleは](https://github.com/rmw-lib/blake3_merkle) 、 `BLOCK_CHUNK` を10に設定すると、(1 << 10)*1024 = 1MBごとに32バイトのハッシュを出力し、0.3‱だけオーバーヘッドが追加されるだけです。

`./examples/main.rs` 以下の通りです。

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

`./example.main.sh`を実行すると、次のような出力が得られます。

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