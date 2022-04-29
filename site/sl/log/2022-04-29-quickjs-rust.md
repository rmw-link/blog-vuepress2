# Spreminjanje quickjs za uvoz funkcij rust - nov način razmišljanja o razširitvi Krakena

## Repozitorij kode

* [github](https://github.com/rmw-lib/quickjs-rust)
* [gitee](https://gitee.com/rmw-link/quickjs-rust)
* [gitflic](https://gitflic.ru/project/rmw-link/quickjs-rust)

## Izvor

[Kraken](https://openkraken.com) je visoko zmogljiv spletni pogon za upodabljanje, ki temelji na spletnem mestu `Flutter` in kot skriptni pogon uporablja [quickjs](https://github.com/openkraken/kraken/tree/main/bridge/third_party/quickjs).

Želel sem napisati nekaj razširitev za Kraken z uporabo `rust`.

Kraken [podpira pisanje razširitev z uporabo `dart`](https://openkraken.com/guide/advanced/custom-js-api) .

Uporaba spletne strani [`flutter_rust_bridge`](https://github.com/fzyzcjy/flutter_rust_bridge) `rust` in `dart`.

Če združimo ti dve točki, ni težko napisati razširitev za Kraken z uporabo spletne strani `rust`.  
Vendar pa se zdi, da so stroški te rešitve visoki, saj je za klic `dart` na naslov `rust` potrebna dodatna zmogljivost, za klic `quickjs` na naslov `dart` pa še ena.

Po drugi strani pa je skupnost `rust` [`rquickjs`](https://github.com/DelSkayn/rquickjs) takih klicev v knjižnico `quickjs` v `rust`.  
Vendar pa namesto vgradnje `quickjs`kličejo `quickjs` in jih ni mogoče uporabiti za čarovnijo `quickjs`.

V tej kodni zbirki sem uporabil novo rešitev: neposredno spreminjanje izvorne kode `quickjs` za podporo razširitve `rust`.

To je splošna rešitev, ki se lahko uporablja ne le za spreminjanje sistema Kraken, temveč tudi za vsa ogrodja in knjižnice, ki vsebujejo `quickjs`.

## Predstavitev

Koda test.js je naslednja:

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

Zagon `./quickjs/qjs test.js`, izhod :

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

### Izvajanje fib v rustu

Funkcija fib, uvožena v js, je iz `rust/src/export/fib.rs`, koda pa je naslednja :

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

Trenutno makro postopka `#[js]` samo doda konstanto `fib_args_len`, ki določa število argumentov funkcije.

V prihodnosti bo mogoče napisati makro postopka `./rust_macro`, ki bo omogočal popolnoma samodejni izvoz funkcij.

### Izvajanje funkcije spanja v rezu

Funkcija spanja, uvožena v js, je iz `rust/src/export/sleep.rs`, koda pa je naslednja :

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

Kot lahko vidite zgoraj, so vse izvožene funkcije opredeljene v imeniku `./rust/src/export`. Ta imenik `mod.rs` se samodejno ustvari, ko se zažene `./rust/build.xsh`, in vanj izvozi vse datoteke `.rs`.

### Branje in potrjevanje vhodnih parametrov js

Parametri se preberejo in potrdijo na naslovu `src/js/arg.rs` z naslednjo kodo :

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

Trenutno se preverja samo število argumentov in bere se tip i64.

Te funkcije lahko po potrebi dodate, glejte funkcije v [qjs_sys](https://docs.rs/qjs-sys/0.1.2/qjs_sys/), ki se začnejo s `JS_To`.

### Pretvorba podatkovnih tipov iz rje v js

Pretvorba tipa se izvede na naslovu `src/js/val.rs` z naslednjo kodo :

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

Za pretvorbo iz `None`, `()`, `i64`in CString v `js` so opredeljene samo štiri vrste. Dodate jih lahko, kolikor želite.

Več podatkovnih tipov je mogoče deklarirati v funkcijah v [qjs_sys](https://docs.rs/qjs-sys/0.1.2/qjs_sys/), ki se začnejo s `JS_New`.

## Razvojno okolje

Razvijam na prenosnem računalniku Apple, rust uporablja 1.62.0-nightly.

Najprej namestite [direnv](https://direnv.net), pojdite v imenik in `direnv allow` za nekaj časa

Namestite python3, nato `pip3 install -r ./requirements.txt`

zaženite `./build.xsh`, da sestavite in zaženete demo

Privzeto bo uradna shramba quickjs klonirana, če želite spremeniti quickjs v shrambi Kraken, najprej

`git clone --recursive git@github.com:openkraken/kraken.git --depth=1`

nato naredite naslednje

```bash
rm -rf quickjs
ln -s ../kraken/bridge/third_party/quickjs .
```

Nazadnje ponovno zaženite `./build.xsh`

## Struktura imenika

* `./quickjs_rust`  
  Spreminjanje datoteke c kode quickjs
  
* `./quickjs_ffi`  
  Izvoz funkcij iz datoteke z glavo `quickjs` v `rust`
  
* `./rust`  
  Uporabite `rust` za izvajanje funkcij v `quickjs`.
  
  * `./rust/src/qjs.rs`  
    Izvajanje asinhronih klicev. Ker je `quickjs` enonitna, so funkcijski klici, ki vključujejo `quckjs`, zapisani v glavni niti.
* `./rust_macro`  
  `rust` Izvajanje makro postopka `#[js]`
  
  V prihodnosti si oglejte [wasmedge-quickjs](https://github.com/second-state/wasmedge-quickjs/blob/70efe8520dc65636cb81b7225e2a6dae47cfad49/src/quickjs_sys/mod.rs#L122) za samodejni izvoz funkcij rust v funkcije js. [wasmedge-quickjs → JsFunctionTrampoline](https://github.com/second-state/wasmedge-quickjs/blob/70efe8520dc65636cb81b7225e2a6dae47cfad49/src/quickjs_sys/mod.rs#L122)
  

## Gradnja skript `build.xsh`

Brez nadaljnjega preidimo naravnost k izvorni kodi skripte za sestavljanje `build.xsh`.

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

## Razlaga načela

### `quickjs_rust/patch.py`

Če zaženete `./quickjs_rust/patch.py`, se v izvorno kodo `quickjs` vnese nekaj manjših sprememb.

Ena od funkcij `JS_AddRust` se uporablja za injiciranje v modul rust.

`rust_run` se vbrizga v `JS_ExecutePendingJob`, da pokliče asinhrone funkcije.

Zaslonska slika vseh sprememb je prikazana spodaj :

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/ep2Xgg.png)

### `quickjs_rust.h`

Iz zgornjih sprememb je razvidno, da smo uvedli novo datoteko glave `quickjs_rust.h` z naslednjo kodo

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

Vidite lahko, da `quickjs_rust/quickjs_rust.h` uvaja `quickjs_rust/js_rust_funcs.h`, ki se samodejno ustvari iz datoteke z glavo funkcije rust export `rust/rust.h` in je ne smete ročno spreminjati.

Spletna stran `rust/rust.h` pa se ustvari s klicem cbindgen iz spletne strani `./rust/build.xsh`.

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

## Razvojne težave : Memo

### `quickjs_ffi`

Koda iz [quijine/main/quijine_core/src/ffi.rs](https://raw.githubusercontent.com/taskie/quijine/main/quijine_core/src/ffi.rs)

z nekaj manjšimi spremembami, ki nadomeščajo

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

na .

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

Spremeni '. /rust/Cargo.toml' kot sledi, pri čemer ohranite samo staticlib

```toml
[lib]
#crate-type = ["lib", "cdylib", "staticlib"]
crate-type = ["staticlib"]
```

## Reference

0. Od gonilnika `JS` do izvajalnega okolja `JS` [(zgoraj](https://github.com/doodlewind/blog/blob/master/source/_posts/js-engine-to-js-runtime-1.md) ) [(spodaj)](https://github.com/doodlewind/blog/blob/master/source/_posts/js-engine-to-js-runtime-2.md)
1. [Razvoj izvornega modula za `QuickJS` v jeziku C](https://github.com/quickjs-zh/QuickJS/wiki/%E4%BD%BF%E7%94%A8C%E8%AF%AD%E8%A8%80%E4%B8%BAQuickJS%E5%BC%80%E5%8F%91%E4%B8%80%E4%B8%AA%E5%8E%9F%E7%94%9F%E6%A8%A1%E5%9D%97)
2. [Uporaba rje za izvajanje vmesnika JS API](https://wasmedge.org/book/en/dev/js/rust.html)
3. [Primeri QuickJS](https://github.com/Kozova1/quickjs-example)
4. [rust-bindgen](https://rust-lang.github.io/rust-bindgen/)
5. [Kako ustvariti asinhrono kodo za `QuickJS`](https://calbertts.medium.com/how-to-create-asynchronous-apis-for-quickjs-8aca5488bb2e)
6. [rquickjs → JS_NewPromiseCapability](https://github.com/DelSkayn/rquickjs/blob/master/core/src/context/ctx.rs#L104)
7. [wasmedge-quickjs → new_promise](https://github.com/second-state/wasmedge-quickjs/blob/8a65582265ecdd3171380feebf56b3bb8c34d183/src/quickjs_sys/mod.rs#L515)
8. [wasmedge-quickjs → JsMetoda](https://github.com/second-state/wasmedge-quickjs/blob/da887752fdc9c36aca0f4b7499c5b115862ce771/src/internal_module/wasi_net_module.rs#L46)
9. [wasmedge-quickjs → klic](https://github.com/second-state/wasmedge-quickjs/blob/8a65582265ecdd3171380feebf56b3bb8c34d183/src/quickjs_sys/mod.rs#L756)
10. [Neopazna past - ključavnice v sistemu Rust](https://mp.weixin.qq.com/s/BKto24ItwXbeHon_LaF_0w)

## O

Ta projekt je del kodnega projekta **rmw.link ( [rmw.link](//rmw.link)** ).

![rmw.link](https://raw.githubusercontent.com/rmw-link/logo/master/rmw.red.bg.svg)