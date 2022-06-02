# Árvore Merkle baseada em blake3

[blake3](https://github.com/BLAKE3-team/BLAKE3) baseia-se numa implementação de merkle tree, mas a interface exposta não exporta merkle trees.

[bao](https://github.com/oconnor663/bao) implementa a validação blake3 streaming, mas não suporta o redimensionamento dos [pedaços](https://github.com/oconnor663/bao/issues/34) subjacentes [(suporta "grupos de pedaços" maiores para reduzir o espaço aéreo](https://github.com/oconnor663/bao/issues/34) ).

A implementação actual da bao consome 6% de espaço de armazenamento extra para registar hashes de validação, o que é uma sobrecarga significativa para um servidor de indexação de conteúdos.

A minha implementação de [blake3_merkle](https://github.com/rmw-lib/blake3_merkle), quando `BLOCK_CHUNK` está definida para 10, produz um hash de 32 bytes para cada (1 <<10)*1024 = 1MB, adicionando apenas 0.3‱ de despesas gerais adicionais.

`./examples/main.rs` Como se segue :

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

Corre `./example.main.sh`e o resultado será parecido com o seguinte

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