# Quickjs modifikavimas, kad būtų galima importuoti rūdžių funkcijas - naujas mąstymo apie "Kraken" išplėtimą būdas

## Kodų saugykla

* [github](https://github.com/rmw-lib/quickjs-rust)
* [gitee](https://gitee.com/rmw-link/quickjs-rust)
* [gitflic](https://gitflic.ru/project/rmw-link/quickjs-rust)
* [bitbucket](https://bitbucket.org/rmw-link/quickjs-rust)

## Kilmė

" [Kraken"](https://openkraken.com) yra didelio našumo žiniatinklio atvaizdavimo variklis, paremtas `Flutter`, kuriame kaip scenarijų variklis naudojamas [quickjs](https://github.com/openkraken/kraken/tree/main/bridge/third_party/quickjs).

Norėjau parašyti keletą "Kraken" plėtinių naudodamas `rust`.

"Kraken" [palaiko plėtinių rašymą naudojant `dart`](https://openkraken.com/guide/advanced/custom-js-api) .

Naudojant [`flutter_rust_bridge`](https://github.com/fzyzcjy/flutter_rust_bridge) `rust` ir `dart`.

Sujungus šiuos du dalykus, nesunku parašyti "Kraken" plėtinius naudojant `rust`.  
Tačiau šio sprendimo našumo sąnaudos yra didelės, nes `dart` skambinant į `rust`, o `quickjs` skambinant į `dart`, patiriama našumo nuostolių.

Kita vertus, nors `rust` bendruomenė [`rquickjs`](https://github.com/DelSkayn/rquickjs) tokių skambučių į `quickjs` biblioteką `rust`.  
Tačiau vietoj įterpimo `quickjs`jie vadinasi `quickjs` ir negali būti naudojami stebuklingam `quickjs`.

Šioje kodų bazėje aš įgyvendinau naują sprendimą: tiesiogiai pakeičiau `quickjs` išeities kodą, kad jis palaikytų `rust` plėtinį.

Tai bendras sprendimas, kurį galima naudoti ne tik "Kraken" modifikavimui, bet ir visiems karkasams ir bibliotekoms, kuriuose įdiegta `quickjs`.

## Demonstracinis

Test.js kodas yra toks:

```js
const try_run = (func, ...args) => {
  try {
    func(...args)
  } catch (err) {
    console.log('❌', err.message)
    console.log(err.stack)
  }
};

import * as rust from 'rust'
console.log("export from rust :", Object.keys(rust))

import {
  fib,
  sleep
} from 'rust'

(async () => {

  console.log('begin sleep 2s')
  await sleep(2000);
  console.log('sleep done')

  console.log('fib(3) =', fib(3));

  console.log("try catch example :")
  try_run(fib);
  try_run(fib, '*');

})()
```

Paleisti `./quickjs/qjs test.js`, išvestis :

```
export from rust : fib,sleep
begin sleep 2s
sleep done
fib(3) = 6
try catch example :
❌ miss : args need 1 pass 0
    at fib (native)
    at try_run (test.js:8)
    at <anonymous> (test.js:27)

❌ not number : args position 0
    at fib (native)
    at try_run (test.js:6)
    at <anonymous> (test.js:28)
```

### Fib įgyvendinimas rūdžių sistemoje

Fib funkcija importuota js yra iš `rust/src/export/fib.rs` ir kodas yra toks :

```rust
use crate::js::{self, arg};
use quickjs_ffi::{JSContext, JSValue};
use rust_macro::js;
use std::os::raw::c_int;

#[js]
pub fn fib(n: i64) -> i64 {
  if n <= 1 {
    return if n == 1 { 1 } else { 0 };
  }
  n + fib(n - 1)
}

#[no_mangle]
pub extern "C" fn js_fib(
  ctx: *mut JSContext,
  _this: JSValue,
  argc: c_int,
  argv: *mut JSValue,
) -> JSValue {
  if let Err(err) = arg::arg_miss(ctx, argc, fib_args_len) {
    return err;
  }
  match arg::arg_i64(ctx, argv, 0) {
    Err(err) => err,
    Ok(n) => js::val(ctx, fib(n)),
  }
}
```

Šiuo metu procedūros makro `#[js]` tik prideda konstantą `fib_args_len`, kuri nurodo funkcijos argumentų skaičių.

Ateityje bus galima parašyti procedūros makro `./rust_macro`, kad būtų galima visiškai automatiškai eksportuoti funkcijas.

### Miego funkcijos įgyvendinimas rust sistemoje

Į js importuota miego funkcija yra iš `rust/src/export/sleep.rs`, o kodas yra toks :

```rust
use crate::js::{self, arg};
use quickjs_ffi::{JSContext, JSValue};
use rust_macro::js;
use std::os::raw::c_int;

#[js]
pub fn fib(n: i64) -> i64 {
  if n <= 1 {
    return if n == 1 { 1 } else { 0 };
  }
  n + fib(n - 1)
}

#[no_mangle]
pub extern "C" fn js_fib(
  ctx: *mut JSContext,
  _this: JSValue,
  argc: c_int,
  argv: *mut JSValue,
) -> JSValue {
  if let Err(err) = arg::arg_miss(ctx, argc, fib_args_len) {
    return err;
  }
  match arg::arg_i64(ctx, argv, 0) {
    Err(err) => err,
    Ok(n) => js::val(ctx, fib(n)),
  }
}
use crate::{js::arg, qjs::run};
use async_io::Timer;
use quickjs_ffi::{JSContext, JSValue};
use rust_macro::js;
use std::{os::raw::c_int, time::Duration};

#[js]
pub async fn sleep(n: u64) {
  Timer::after(Duration::from_millis(n)).await;
}

#[no_mangle]
pub extern "C" fn js_sleep(
  ctx: *mut JSContext,
  _this: JSValue,
  argc: c_int,
  argv: *mut JSValue,
) -> JSValue {
  if let Err(err) = arg::arg_miss(ctx, argc, sleep_args_len) {
    return err;
  }
  match arg::arg_i64(ctx, argv, 0) {
    Err(err) => err,
    Ok(n) => run(ctx, async move {
      sleep(n as u64).await;
      Ok(())
    }),
  }
}
```

Kaip matote pirmiau, visos eksportuojamos funkcijos apibrėžtos kataloge `./rust/src/export`. Šis katalogas `mod.rs` automatiškai sukuriamas, kai paleidžiamas `./rust/build.xsh`, eksportuojant visus jame esančius `.rs` failus.

### Įeinančių js parametrų skaitymas ir patvirtinimas

Parametrai nuskaitomi ir patvirtinami adresu `src/js/arg.rs` naudojant šį kodą:

```rust
use crate::js::{self, arg};
use quickjs_ffi::{JSContext, JSValue};
use rust_macro::js;
use std::os::raw::c_int;

#[js]
pub fn fib(n: i64) -> i64 {
  if n <= 1 {
    return if n == 1 { 1 } else { 0 };
  }
  n + fib(n - 1)
}

#[no_mangle]
pub extern "C" fn js_fib(
  ctx: *mut JSContext,
  _this: JSValue,
  argc: c_int,
  argv: *mut JSValue,
) -> JSValue {
  if let Err(err) = arg::arg_miss(ctx, argc, fib_args_len) {
    return err;
  }
  match arg::arg_i64(ctx, argv, 0) {
    Err(err) => err,
    Ok(n) => js::val(ctx, fib(n)),
  }
}
use crate::{js::arg, qjs::run};
use async_io::Timer;
use quickjs_ffi::{JSContext, JSValue};
use rust_macro::js;
use std::{os::raw::c_int, time::Duration};

#[js]
pub async fn sleep(n: u64) {
  Timer::after(Duration::from_millis(n)).await;
}

#[no_mangle]
pub extern "C" fn js_sleep(
  ctx: *mut JSContext,
  _this: JSValue,
  argc: c_int,
  argv: *mut JSValue,
) -> JSValue {
  if let Err(err) = arg::arg_miss(ctx, argc, sleep_args_len) {
    return err;
  }
  match arg::arg_i64(ctx, argv, 0) {
    Err(err) => err,
    Ok(n) => run(ctx, async move {
      sleep(n as u64).await;
      Ok(())
    }),
  }
}
use crate::js::throw;

use quickjs_ffi::{JSContext, JSValue, JS_IsNumber, JS_ToInt64};
use std::{mem::MaybeUninit, os::raw::c_int};

pub(crate) fn arg_miss(ctx: *mut JSContext, argc: c_int, need: c_int) -> Result<(), JSValue> {
  if argc < need {
    throw(ctx, format!("miss : args need {need} pass {argc}"))?
  }
  Ok(())
}

pub(crate) fn arg_i64(ctx: *mut JSContext, argv: *mut JSValue, pos: isize) -> Result<i64, JSValue> {
  unsafe {
    let val = *argv.offset(pos);
    if JS_IsNumber(val) == 0 {
      throw(ctx, format!("not number : args position {pos}"))?
    }
    let mut n = MaybeUninit::uninit();
    JS_ToInt64(ctx, n.as_mut_ptr() as _, val);
    Ok(n.assume_init())
  }
}
```

Šiuo metu tikrinamas tik argumentų skaičius ir skaitomas i64 tipas.

Šias funkcijas galite pridėti pagal poreikį, žr. [qjs_sys](https://docs.rs/qjs-sys/0.1.2/qjs_sys/) funkcijas, prasidedančias `JS_To`.

### Duomenų tipų konvertavimas iš rust į js

Tipo konvertavimas atliekamas adresu `src/js/val.rs` naudojant šį kodą :

```rust
use crate::js::{self, arg};
use quickjs_ffi::{JSContext, JSValue};
use rust_macro::js;
use std::os::raw::c_int;

#[js]
pub fn fib(n: i64) -> i64 {
  if n <= 1 {
    return if n == 1 { 1 } else { 0 };
  }
  n + fib(n - 1)
}

#[no_mangle]
pub extern "C" fn js_fib(
  ctx: *mut JSContext,
  _this: JSValue,
  argc: c_int,
  argv: *mut JSValue,
) -> JSValue {
  if let Err(err) = arg::arg_miss(ctx, argc, fib_args_len) {
    return err;
  }
  match arg::arg_i64(ctx, argv, 0) {
    Err(err) => err,
    Ok(n) => js::val(ctx, fib(n)),
  }
}
use crate::{js::arg, qjs::run};
use async_io::Timer;
use quickjs_ffi::{JSContext, JSValue};
use rust_macro::js;
use std::{os::raw::c_int, time::Duration};

#[js]
pub async fn sleep(n: u64) {
  Timer::after(Duration::from_millis(n)).await;
}

#[no_mangle]
pub extern "C" fn js_sleep(
  ctx: *mut JSContext,
  _this: JSValue,
  argc: c_int,
  argv: *mut JSValue,
) -> JSValue {
  if let Err(err) = arg::arg_miss(ctx, argc, sleep_args_len) {
    return err;
  }
  match arg::arg_i64(ctx, argv, 0) {
    Err(err) => err,
    Ok(n) => run(ctx, async move {
      sleep(n as u64).await;
      Ok(())
    }),
  }
}
use crate::js::throw;

use quickjs_ffi::{JSContext, JSValue, JS_IsNumber, JS_ToInt64};
use std::{mem::MaybeUninit, os::raw::c_int};

pub(crate) fn arg_miss(ctx: *mut JSContext, argc: c_int, need: c_int) -> Result<(), JSValue> {
  if argc < need {
    throw(ctx, format!("miss : args need {need} pass {argc}"))?
  }
  Ok(())
}

pub(crate) fn arg_i64(ctx: *mut JSContext, argv: *mut JSValue, pos: isize) -> Result<i64, JSValue> {
  unsafe {
    let val = *argv.offset(pos);
    if JS_IsNumber(val) == 0 {
      throw(ctx, format!("not number : args position {pos}"))?
    }
    let mut n = MaybeUninit::uninit();
    JS_ToInt64(ctx, n.as_mut_ptr() as _, val);
    Ok(n.assume_init())
  }
}
use quickjs_ffi::{JSContext, JSValue, JS_NewInt64, JS_NewString, JS_NULL, JS_UNDEFINED};
use std::ffi::CString;

pub enum Val {
  None,
  Undefined,
  I64(i64),
  CString(CString),
}

impl From<()> for Val {
  fn from(_: ()) -> Self {
    Val::Undefined
  }
}

impl From<i64> for Val {
  fn from(t: i64) -> Self {
    Val::I64(t)
  }
}

impl From<CString> for Val {
  fn from(t: CString) -> Self {
    Val::CString(t)
  }
}

pub(crate) fn val(ctx: *mut JSContext, t: impl Into<Val>) -> JSValue {
  match t.into() {
    Val::None => JS_NULL,
    Val::Undefined => JS_UNDEFINED,
    Val::I64(n) => unsafe { JS_NewInt64(ctx, n) },
    Val::CString(cstr) => unsafe { JS_NewString(ctx, cstr.as_ptr()) },
  }
}
```

Konvertuoti iš `None`, `()`, `i64`ir CString į `js` galima tik keturis tipus. Galite pridėti tiek, kiek norite.

Daugiau duomenų tipų galima deklaruoti [qjs_sys](https://docs.rs/qjs-sys/0.1.2/qjs_sys/) funkcijose, pradedant `JS_New`.

## Kūrimo aplinka

Kuriu "Apple" nešiojamajame kompiuteryje, rūdys naudoja 1.62.0-nightly.

Pirmiausia įdiekite [direnv](https://direnv.net), eikite į katalogą ir `direnv allow`, o

Įdiekite python3, tada `pip3 install -r ./requirements.txt`

paleisti `./build.xsh`, kad būtų sukompiliuota ir paleista demonstracinė versija

Pagal numatytuosius nustatymus oficiali quickjs saugykla bus klonuota, jei norite pakeisti "Kraken" saugykloje esantį quickjs, pirmiausia

`git clone --recursive git@github.com:openkraken/kraken.git --depth=1`

tada atlikite šiuos veiksmus

```bash
rm -rf quickjs
ln -s ../kraken/bridge/third_party/quickjs .
```

Galiausiai dar kartą paleiskite `./build.xsh`

## Katalogo struktūra

* `./quickjs_rust`  
  Quickjs kodo c failo keitimas
  
* `./quickjs_ffi`  
  Eksportuokite funkcijas iš `quickjs` antraštės failo į `rust`
  
* `./rust`  
  Naudokite `rust`, kad įgyvendintumėte `quickjs` funkcijas.
  
  * `./rust/src/qjs.rs`  
    Asinchroninių skambučių įgyvendinimas. Kadangi `quickjs` yra vienos gijos, su `quckjs` susiję funkcijų iškvietimai rašomi pagrindinėje gijoje.
* `./rust_macro`  
  `rust` Procedūros makro `#[js]` įgyvendinimas
  
  Ateityje žr. [wasmedge-quickjs](https://github.com/second-state/wasmedge-quickjs/blob/70efe8520dc65636cb81b7225e2a6dae47cfad49/src/quickjs_sys/mod.rs#L122) dėl automatinio rust funkcijų eksporto į js funkcijas. [wasmedge-quickjs → JsFunctionTrampoline](https://github.com/second-state/wasmedge-quickjs/blob/70efe8520dc65636cb81b7225e2a6dae47cfad49/src/quickjs_sys/mod.rs#L122)
  

## Statybos scenarijai `build.xsh`

Nedelsdami pereikime tiesiai prie `build.xsh` kūrimo scenarijaus išeities kodo.

```xonsh
#!/usr/bin/env xonsh

from pathlib import Path
from os.path import dirname,abspath,exists,join
PWD = dirname(abspath(__file__))
cd @(PWD)

p".xonshrc".exists() && source .xonshrc

quickjs = 'quickjs'

if not exists(quickjs):
  git clone git@github.com:bellard/@(quickjs).git --depth=1

./quickjs_rust/patch.py

./rust/build.xsh
./quickjs_rust/gen.py

def ln_s(li):
  for arg in li.split(' '):
    fp = join(quickjs,arg)
    if not exists(fp):
      ln -s @(PWD)/@(arg) @(fp)

ln_s('quickjs_rust rust quickjs_ffi rust_macro')

cd @(quickjs)
make qjs

cd @(PWD)
./quickjs/qjs --unhandled-rejection -m test.js 2>&1 | tee test.js.out
```

## Principo paaiškinimas

### `quickjs_rust/patch.py`

Paleidus `./quickjs_rust/patch.py`, `quickjs` išeities kodas bus šiek tiek pakeistas.

Viena iš funkcijų `JS_AddRust` naudojama į rust modulį.

`rust_run` yra įterpiamas į `JS_ExecutePendingJob`, kad būtų galima iškviesti asinchronines funkcijas.

Toliau pateikiama visų pakeitimų ekrano kopija:

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/ep2Xgg.png)

### `quickjs_rust.h`

Iš pirmiau pateiktų pakeitimų matyti, kad įvedėme naują antraštės failą `quickjs_rust.h` su tokiu kodu

```c
#ifndef QUICKJS_RUST_H
#define QUICKJS_RUST_H

#include "../quickjs/quickjs.h"
#include "../rust/rust.h"

#define countof(x) (sizeof(x) / sizeof((x)[0]))
#define JS_RUSTFUNC_DEF(name) JS_CFUNC_DEF(#name, name##_args_len, js_##name)
#include "./js_rust_funcs.h"

static const unsigned int js_rust_funcs_count = countof(js_rust_funcs);

static int
js_rust_init(JSContext* ctx, JSModuleDef* m)
{
  return JS_SetModuleExportList(ctx, m, js_rust_funcs,
      js_rust_funcs_count);
}

#define JS_INIT_MODULE js_init_module_rust

JSModuleDef* JS_INIT_MODULE(JSContext* ctx, const char* module_name)
{
  JSModuleDef* m;
  m = JS_NewCModule(ctx, module_name, js_rust_init);
  if (!m)
    return NULL;
  js_rust_init(ctx, m);
  return m;
}

void JS_AddRust(JSContext* ctx, JSRuntime* rt)
{
  JSModuleDef* m = JS_INIT_MODULE(ctx, "rust");
  for (unsigned int i = 0; i < js_rust_funcs_count; i++) {
    JS_AddModuleExport(ctx, m, js_rust_funcs[i].name);
  }
  rust_init(ctx, rt);
}

#endif
```

### `rust/rust.h`

Matote, kad `quickjs_rust/quickjs_rust.h` įveda `quickjs_rust/js_rust_funcs.h`, kuris automatiškai sukuriamas iš rust eksporto funkcijos antraštės failo `rust/rust.h` ir neturėtų būti keičiamas rankiniu būdu.

O `rust/rust.h` generuojamas iš `./rust/build.xsh` iškvietus cbindgen.

### `rust/build.xsh`

```xonsh
#!/usr/bin/env xonsh

from os.path import dirname,abspath
import platform
PWD = dirname(abspath(__file__))
cd @(PWD)

p"../.xonshrc".exists() && source ../.xonshrc

./src/export/mod.gen.py

system = platform.system().lower()
if system == 'darwin':
  system = f'apple-{system}'

TARGET=f'{platform.machine()}-{system}'

def cbindgen():
  cbindgen -q --config cbindgen.toml --crate rust --output rust.h

try:
  cbindgen()
except:
  cargo clean
  cbindgen()

cargo build \
--release \
-Z build-std=std,panic_abort \
-Z build-std-features=panic_immediate_abort \
--target @(TARGET)

mv ./target/@(TARGET)/release/librust.a ./target/release
```

## Pastabos dėl plėtros

### `quickjs_ffi`

Kodas iš [quijine/main/quijine_core/src/ffi.rs](https://raw.githubusercontent.com/taskie/quijine/main/quijine_core/src/ffi.rs)

su nedideliais pakeitimais, pakeičiant

```rust
use crate::js::{self, arg};
use quickjs_ffi::{JSContext, JSValue};
use rust_macro::js;
use std::os::raw::c_int;

#[js]
pub fn fib(n: i64) -> i64 {
  if n <= 1 {
    return if n == 1 { 1 } else { 0 };
  }
  n + fib(n - 1)
}

#[no_mangle]
pub extern "C" fn js_fib(
  ctx: *mut JSContext,
  _this: JSValue,
  argc: c_int,
  argv: *mut JSValue,
) -> JSValue {
  if let Err(err) = arg::arg_miss(ctx, argc, fib_args_len) {
    return err;
  }
  match arg::arg_i64(ctx, argv, 0) {
    Err(err) => err,
    Ok(n) => js::val(ctx, fib(n)),
  }
}
use crate::{js::arg, qjs::run};
use async_io::Timer;
use quickjs_ffi::{JSContext, JSValue};
use rust_macro::js;
use std::{os::raw::c_int, time::Duration};

#[js]
pub async fn sleep(n: u64) {
  Timer::after(Duration::from_millis(n)).await;
}

#[no_mangle]
pub extern "C" fn js_sleep(
  ctx: *mut JSContext,
  _this: JSValue,
  argc: c_int,
  argv: *mut JSValue,
) -> JSValue {
  if let Err(err) = arg::arg_miss(ctx, argc, sleep_args_len) {
    return err;
  }
  match arg::arg_i64(ctx, argv, 0) {
    Err(err) => err,
    Ok(n) => run(ctx, async move {
      sleep(n as u64).await;
      Ok(())
    }),
  }
}
use crate::js::throw;

use quickjs_ffi::{JSContext, JSValue, JS_IsNumber, JS_ToInt64};
use std::{mem::MaybeUninit, os::raw::c_int};

pub(crate) fn arg_miss(ctx: *mut JSContext, argc: c_int, need: c_int) -> Result<(), JSValue> {
  if argc < need {
    throw(ctx, format!("miss : args need {need} pass {argc}"))?
  }
  Ok(())
}

pub(crate) fn arg_i64(ctx: *mut JSContext, argv: *mut JSValue, pos: isize) -> Result<i64, JSValue> {
  unsafe {
    let val = *argv.offset(pos);
    if JS_IsNumber(val) == 0 {
      throw(ctx, format!("not number : args position {pos}"))?
    }
    let mut n = MaybeUninit::uninit();
    JS_ToInt64(ctx, n.as_mut_ptr() as _, val);
    Ok(n.assume_init())
  }
}
use quickjs_ffi::{JSContext, JSValue, JS_NewInt64, JS_NewString, JS_NULL, JS_UNDEFINED};
use std::ffi::CString;

pub enum Val {
  None,
  Undefined,
  I64(i64),
  CString(CString),
}

impl From<()> for Val {
  fn from(_: ()) -> Self {
    Val::Undefined
  }
}

impl From<i64> for Val {
  fn from(t: i64) -> Self {
    Val::I64(t)
  }
}

impl From<CString> for Val {
  fn from(t: CString) -> Self {
    Val::CString(t)
  }
}

pub(crate) fn val(ctx: *mut JSContext, t: impl Into<Val>) -> JSValue {
  match t.into() {
    Val::None => JS_NULL,
    Val::Undefined => JS_UNDEFINED,
    Val::I64(n) => unsafe { JS_NewInt64(ctx, n) },
    Val::CString(cstr) => unsafe { JS_NewString(ctx, cstr.as_ptr()) },
  }
}
pub use libquickjs_sys::*;
```

į

```rust
use crate::js::{self, arg};
use quickjs_ffi::{JSContext, JSValue};
use rust_macro::js;
use std::os::raw::c_int;

#[js]
pub fn fib(n: i64) -> i64 {
  if n <= 1 {
    return if n == 1 { 1 } else { 0 };
  }
  n + fib(n - 1)
}

#[no_mangle]
pub extern "C" fn js_fib(
  ctx: *mut JSContext,
  _this: JSValue,
  argc: c_int,
  argv: *mut JSValue,
) -> JSValue {
  if let Err(err) = arg::arg_miss(ctx, argc, fib_args_len) {
    return err;
  }
  match arg::arg_i64(ctx, argv, 0) {
    Err(err) => err,
    Ok(n) => js::val(ctx, fib(n)),
  }
}
use crate::{js::arg, qjs::run};
use async_io::Timer;
use quickjs_ffi::{JSContext, JSValue};
use rust_macro::js;
use std::{os::raw::c_int, time::Duration};

#[js]
pub async fn sleep(n: u64) {
  Timer::after(Duration::from_millis(n)).await;
}

#[no_mangle]
pub extern "C" fn js_sleep(
  ctx: *mut JSContext,
  _this: JSValue,
  argc: c_int,
  argv: *mut JSValue,
) -> JSValue {
  if let Err(err) = arg::arg_miss(ctx, argc, sleep_args_len) {
    return err;
  }
  match arg::arg_i64(ctx, argv, 0) {
    Err(err) => err,
    Ok(n) => run(ctx, async move {
      sleep(n as u64).await;
      Ok(())
    }),
  }
}
use crate::js::throw;

use quickjs_ffi::{JSContext, JSValue, JS_IsNumber, JS_ToInt64};
use std::{mem::MaybeUninit, os::raw::c_int};

pub(crate) fn arg_miss(ctx: *mut JSContext, argc: c_int, need: c_int) -> Result<(), JSValue> {
  if argc < need {
    throw(ctx, format!("miss : args need {need} pass {argc}"))?
  }
  Ok(())
}

pub(crate) fn arg_i64(ctx: *mut JSContext, argv: *mut JSValue, pos: isize) -> Result<i64, JSValue> {
  unsafe {
    let val = *argv.offset(pos);
    if JS_IsNumber(val) == 0 {
      throw(ctx, format!("not number : args position {pos}"))?
    }
    let mut n = MaybeUninit::uninit();
    JS_ToInt64(ctx, n.as_mut_ptr() as _, val);
    Ok(n.assume_init())
  }
}
use quickjs_ffi::{JSContext, JSValue, JS_NewInt64, JS_NewString, JS_NULL, JS_UNDEFINED};
use std::ffi::CString;

pub enum Val {
  None,
  Undefined,
  I64(i64),
  CString(CString),
}

impl From<()> for Val {
  fn from(_: ()) -> Self {
    Val::Undefined
  }
}

impl From<i64> for Val {
  fn from(t: i64) -> Self {
    Val::I64(t)
  }
}

impl From<CString> for Val {
  fn from(t: CString) -> Self {
    Val::CString(t)
  }
}

pub(crate) fn val(ctx: *mut JSContext, t: impl Into<Val>) -> JSValue {
  match t.into() {
    Val::None => JS_NULL,
    Val::Undefined => JS_UNDEFINED,
    Val::I64(n) => unsafe { JS_NewInt64(ctx, n) },
    Val::CString(cstr) => unsafe { JS_NewString(ctx, cstr.as_ptr()) },
  }
}
pub use libquickjs_sys::*;
#![allow(non_upper_case_globals)]
#![allow(non_camel_case_types)]
#![allow(non_snake_case)]

include!(concat!(env!("OUT_DIR"), "/c.rs"));
```

### `Undefined symbols for architecture x86_64: "_JS_ToInt32"`

Pakeiskite ". /rust/Cargo.toml' taip, išlaikant tik staticlib

```toml
[lib]
#crate-type = ["lib", "cdylib", "staticlib"]
crate-type = ["staticlib"]
```

## Nuorodos

0. Iš `JS` variklio į `JS` paleidimo laiką [(viršuje](https://github.com/doodlewind/blog/blob/master/source/_posts/js-engine-to-js-runtime-1.md) ) [(apačioje](https://github.com/doodlewind/blog/blob/master/source/_posts/js-engine-to-js-runtime-2.md) )
1. [Gimtojo modulio, skirto svetainei `QuickJS`, kūrimas C kalba](https://github.com/quickjs-zh/QuickJS/wiki/%E4%BD%BF%E7%94%A8C%E8%AF%AD%E8%A8%80%E4%B8%BAQuickJS%E5%BC%80%E5%8F%91%E4%B8%80%E4%B8%AA%E5%8E%9F%E7%94%9F%E6%A8%A1%E5%9D%97)
2. [Naudokite "Rust" JS API įgyvendinti](https://wasmedge.org/book/en/dev/js/rust.html)
3. [QuickJS pavyzdžiai](https://github.com/Kozova1/quickjs-example)
4. [rust-bindgen](https://rust-lang.github.io/rust-bindgen/)
5. [Kaip sukurti asinchroninį kodą svetainėje `QuickJS`](https://calbertts.medium.com/how-to-create-asynchronous-apis-for-quickjs-8aca5488bb2e)
6. [rquickjs → JS_NewPromiseCapability](https://github.com/DelSkayn/rquickjs/blob/master/core/src/context/ctx.rs#L104)
7. [wasmedge-quickjs → new_promise](https://github.com/second-state/wasmedge-quickjs/blob/8a65582265ecdd3171380feebf56b3bb8c34d183/src/quickjs_sys/mod.rs#L515)
8. [wasmedge-quickjs → JsMetodas](https://github.com/second-state/wasmedge-quickjs/blob/da887752fdc9c36aca0f4b7499c5b115862ce771/src/internal_module/wasi_net_module.rs#L46)
9. [wasmedge-quickjs → skambutis](https://github.com/second-state/wasmedge-quickjs/blob/8a65582265ecdd3171380feebf56b3bb8c34d183/src/quickjs_sys/mod.rs#L756)
10. [Nepastebimi spąstai - užraktai "Rust](https://mp.weixin.qq.com/s/BKto24ItwXbeHon_LaF_0w)

## Apie

Šis projektas yra **rmw.link ( [rmw.link](//rmw.link)** ) kodo projekto dalis.

![rmw.link](https://raw.githubusercontent.com/rmw-link/logo/master/rmw.red.bg.svg)