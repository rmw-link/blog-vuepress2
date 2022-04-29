# A quickjs módosítása a rozsda függvények importálásához - a Kraken kiterjesztésének újfajta gondolkodása

## Kódtár

* [github](https://github.com/rmw-lib/quickjs-rust)
* [gitee](https://gitee.com/rmw-link/quickjs-rust)
* [gitflic](https://gitflic.ru/project/rmw-link/quickjs-rust)
* [bitbucket](https://bitbucket.org/rmw-link/quickjs-rust)

## A keletkezés

A [Kraken](https://openkraken.com) egy nagy teljesítményű webes renderelőmotor, amely a `Flutter` oldalon alapul, és a [quickjs-t](https://github.com/openkraken/kraken/tree/main/bridge/third_party/quickjs) használja szkriptelőmotorként.

A Krakenhez akartam írni néhány bővítményt a `rust` segítségével.

A Kraken [támogatja a kiterjesztések írását a `dart` használatával](https://openkraken.com/guide/advanced/custom-js-api).

A használata [`flutter_rust_bridge`](https://github.com/fzyzcjy/flutter_rust_bridge) `rust` és `dart`.

Ezt a két pontot kombinálva nem nehéz Kraken-bővítményeket írni a `rust` segítségével.  
Ennek a megoldásnak a teljesítménye azonban nagynak tűnik, mivel a `dart` a `rust`, a `quickjs` pedig a `dart` meghívása miatt teljesítménycsökkenést szenved el.

Másrészt, míg a `rust` közösség [`rquickjs`](https://github.com/DelSkayn/rquickjs) ilyen hívások a `quickjs` könyvtárhoz a `rust` oldalon.  
Ezek azonban a `quickjs` címet hívják a `quickjs`beágyazása helyett, és nem használhatók a `quickjs` varázslatához.

Ebben a kódbázisban egy új megoldást valósítottam meg: közvetlenül a `quickjs` forráskódot módosítom, hogy támogassa a `rust` kiterjesztést.

Ez egy általános megoldás, amely nem csak a Kraken módosítására használható, hanem minden olyan keretrendszerre és könyvtárra is, amely a `quickjs` oldalt ágyazza be.

## Bemutató

A test.js kód a következő:

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

Futtassa a `./quickjs/qjs test.js`, kimenet :

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

### A fib megvalósítása a rozsdában

A js-ben importált fib függvény a `rust/src/export/fib.rs` oldalról származik, és a kód a következő :

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

Jelenleg az eljárás makró `#[js]` csak egy `fib_args_len`konstanst ad hozzá, amely azonosítja a függvényhez tartozó argumentumok számát.

A jövőben a `./rust_macro` eljárásmakró megírható, hogy lehetővé tegye a teljesen automatikus funkcióexportot.

### Az alvás funkció megvalósítása rozsda nyelven

A js-ben importált sleep függvény a `rust/src/export/sleep.rs` oldalról származik, és a kód a következő :

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

Amint a fentiekben látható, az összes exportált függvény a `./rust/src/export` könyvtárban van definiálva. Ez a `mod.rs` könyvtár automatikusan létrejön a `./rust/build.xsh` futtatásakor, és az összes `.rs` fájlt exportálja alatta.

### A bejövő js paraméterek beolvasása és érvényesítése

A paraméterek beolvasása és ellenőrzése a `src/js/arg.rs` oldalon történik a következő kóddal:

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

Jelenleg csak az argumentumok számát ellenőrzi, és az i64 típusát olvassa.

Ezeket a függvényeket szükség szerint hozzáadhatod, lásd a [qjs_sys](https://docs.rs/qjs-sys/0.1.2/qjs_sys/) függvényeket a `JS_To` címmel kezdődően.

### Adattípus konverzió rozsda-ból js-be

A típuskonverzió a `src/js/val.rs` oldalon történik a következő kóddal :

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

A `None`, `()`, `i64`és a CString és a `js` közötti átalakításhoz csak négy típus van definiálva.

További adattípusokat a [qjs_sys](https://docs.rs/qjs-sys/0.1.2/qjs_sys/) függvényekben lehet deklarálni, kezdve a `JS_New` címmel.

## Fejlesztési környezet

Egy Apple laptopon fejlesztek, a rozsda az 1.62.0-nightly-t használja.

Először telepítse [direnv](https://direnv.net), menjen a könyvtárba, és `direnv allow` egy darabig

Telepítse a python3-at, majd `pip3 install -r ./requirements.txt`

run `./build.xsh` a demó lefordításához és futtatásához

Alapértelmezés szerint a hivatalos quickjs tároló lesz klónozva, ha módosítani szeretné a quickjs-t a Kraken tárolóban, akkor először

`git clone --recursive git@github.com:openkraken/kraken.git --depth=1`

akkor a következőket kell tennie

```bash
rm -rf quickjs
ln -s ../kraken/bridge/third_party/quickjs .
```

Végül futtassa újra a `./build.xsh`

## Könyvtárszerkezet

* `./quickjs_rust`  
  A quickjs kód c fájljának módosítása
  
* `./quickjs_ffi`  
  A függvények exportálása a `quickjs` fejlécfájlból a következő címre `rust`
  
* `./rust`  
  Használja a `rust` címet a `quickjs` függvények megvalósításához.
  
  * `./rust/src/qjs.rs`  
    Aszinkron hívások végrehajtása. Mivel a `quickjs` egyszálas, a `quckjs` -t érintő függvényhívások a főszálban íródnak.
* `./rust_macro`  
  `rust` Az eljárás makrójának végrehajtása `#[js]`
  
  A jövőben lásd [wasmedge-quickjs](https://github.com/second-state/wasmedge-quickjs/blob/70efe8520dc65636cb81b7225e2a6dae47cfad49/src/quickjs_sys/mod.rs#L122) a rozsda függvények automatikus exportálásához js függvényekbe. [wasmedge-quickjs → JsFunctionTrampoline](https://github.com/second-state/wasmedge-quickjs/blob/70efe8520dc65636cb81b7225e2a6dae47cfad49/src/quickjs_sys/mod.rs#L122)
  

## Építési szkriptek `build.xsh`

Minden további nélkül nézzük meg a `build.xsh` build script forráskódját.

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

## Az elv magyarázata

### `quickjs_rust/patch.py`

A `./quickjs_rust/patch.py` futtatása kisebb változtatásokat eszközöl a `quickjs` forráskódban.

A `JS_AddRust` függvények egyike a rozsda modulba történő befecskendezésre szolgál.

A `rust_run` a `JS_ExecutePendingJob` oldalra kerül beillesztésre, hogy aszinkron funkciókat hívjon.

Az összes változtatás képernyőképét az alábbiakban mutatjuk be:

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/ep2Xgg.png)

### `quickjs_rust.h`

A fenti változtatásokból láthatjuk, hogy bevezettünk egy új fejlécfájlt `quickjs_rust.h` a következő kóddal

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

Láthatjuk, hogy a `quickjs_rust/quickjs_rust.h` bevezeti a `quickjs_rust/js_rust_funcs.h`címet, amely automatikusan generálódik a `rust/rust.h` rozsda export függvény fejléc fájlból, és nem kell kézzel módosítani.

A `rust/rust.h` pedig a cbindgen meghívásával jön létre a `./rust/build.xsh` oldalról.

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

## Fejlesztési problémák : Memo

### `quickjs_ffi`

Kód a [quijine/main/quijine_core/src/ffi.rs](https://raw.githubusercontent.com/taskie/quijine/main/quijine_core/src/ffi.rs) fájlból

néhány kisebb módosítással, a

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

a címre.

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

Módosítsa a '. /rust/Cargo.toml' a következőképpen, csak a staticlib-et tartva meg

```toml
[lib]
#crate-type = ["lib", "cdylib", "staticlib"]
crate-type = ["staticlib"]
```

## Hivatkozások

0. A `JS` motortól a `JS` futtatási időig [(fent)](https://github.com/doodlewind/blog/blob/master/source/_posts/js-engine-to-js-runtime-1.md) [(lent)](https://github.com/doodlewind/blog/blob/master/source/_posts/js-engine-to-js-runtime-2.md)
1. [Natív modul fejlesztése a `QuickJS` számára C nyelven](https://github.com/quickjs-zh/QuickJS/wiki/%E4%BD%BF%E7%94%A8C%E8%AF%AD%E8%A8%80%E4%B8%BAQuickJS%E5%BC%80%E5%8F%91%E4%B8%80%E4%B8%AA%E5%8E%9F%E7%94%9F%E6%A8%A1%E5%9D%97)
2. [A Rust használata a JS API megvalósításához](https://wasmedge.org/book/en/dev/js/rust.html)
3. [QuickJS példák](https://github.com/Kozova1/quickjs-example)
4. [rozsda-bindgen](https://rust-lang.github.io/rust-bindgen/)
5. [Hogyan készítsünk aszinkron kódot a `QuickJS` számára](https://calbertts.medium.com/how-to-create-asynchronous-apis-for-quickjs-8aca5488bb2e)?
6. [rquickjs → JS_NewPromiseCapability](https://github.com/DelSkayn/rquickjs/blob/master/core/src/context/ctx.rs#L104)
7. [wasmedge-quickjs → new_promise](https://github.com/second-state/wasmedge-quickjs/blob/8a65582265ecdd3171380feebf56b3bb8c34d183/src/quickjs_sys/mod.rs#L515)
8. [wasmedge-quickjs → JsMethod](https://github.com/second-state/wasmedge-quickjs/blob/da887752fdc9c36aca0f4b7499c5b115862ce771/src/internal_module/wasi_net_module.rs#L46)
9. [wasmedge-quickjs → hívás](https://github.com/second-state/wasmedge-quickjs/blob/8a65582265ecdd3171380feebf56b3bb8c34d183/src/quickjs_sys/mod.rs#L756)
10. [Az észrevétlen csapda - zárak a Rozsdában](https://mp.weixin.qq.com/s/BKto24ItwXbeHon_LaF_0w)

## A oldalról

Ez a projekt az **rmw.link ( [rmw.link](//rmw.link)** ) kódprojekt része.

![rmw.link](https://raw.githubusercontent.com/rmw-link/logo/master/rmw.red.bg.svg)