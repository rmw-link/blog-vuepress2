# Blake3:een perustuva Merkle-puu

[blake3](https://github.com/BLAKE3-team/BLAKE3) perustuu merkle-puuhun, mutta paljastettu käyttöliittymä ei vie merkle-puuta.

[bao](https://github.com/oconnor663/bao) toteuttaa blake3-suoratoistovarmennuksen, mutta ei pysty muuttamaan taustalla olevien [lohkojen](https://github.com/oconnor663/bao/issues/34) kokoa (katso [tuki suuremmille "lohkoryhmille", jotta tilankäyttö vähenisi](https://github.com/oconnor663/bao/issues/34) ).

Tämä tarkoittaa, että bao kuluttaa 6 % ylimääräistä tallennustilaa merkle-puun tallentamiseen, mikä on merkittävä yleiskustannus hajautetulle sisältöindeksille.

Niinpä toteutin [blake3_merkle-toiminnon](https://github.com/rmw-lib/blake3_merkle), jonka avulla saadaan 32 tavua hashia 1 Mt:n sisältöä kohti, ja ylimääräinen tallennuskustannus on 0,3‱.

Merkle-puu tuottaa hasheja, jotka ovat yhdenmukaisia blake3:n kanssa.

Kun sisältö on enintään 1MB, merkle-puussa on vain yksi solmu, ja tämän solmun hash on yhtä suuri kuin blake3:n hash.

`./examples/main.rs` seuraavasti :

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

Suorita `./example.main.sh`ja tuloste on seuraava

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