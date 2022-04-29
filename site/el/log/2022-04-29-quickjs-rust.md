# Τροποποίηση του quickjs για την εισαγωγή συναρτήσεων ρουστίνας - ένας νέος τρόπος σκέψης για την επέκταση του Kraken

## Αποθετήριο κώδικα

* [github](https://github.com/rmw-lib/quickjs-rust)
* [gitee](https://gitee.com/rmw-link/quickjs-rust)
* [gitflic](https://gitflic.ru/project/rmw-link/quickjs-rust)
* [bitbucket](https://bitbucket.org/rmw-link/quickjs-rust)

## Η γένεση

Το [Kraken](https://openkraken.com) είναι μια μηχανή απόδοσης ιστοσελίδων υψηλής απόδοσης βασισμένη στο `Flutter`, η οποία χρησιμοποιεί το [quickjs](https://github.com/openkraken/kraken/tree/main/bridge/third_party/quickjs) ως μηχανή σεναρίων.

Ήθελα να γράψω κάποιες επεκτάσεις στο Kraken χρησιμοποιώντας το `rust`.

Το Kraken [υποστηρίζει τη συγγραφή επεκτάσεων χρησιμοποιώντας το `dart`](https://openkraken.com/guide/advanced/custom-js-api) .

Χρήση του [`flutter_rust_bridge`](https://github.com/fzyzcjy/flutter_rust_bridge) `rust` και `dart`.

Συνδυάζοντας αυτά τα δύο σημεία, δεν είναι δύσκολο να γράψετε επεκτάσεις Kraken χρησιμοποιώντας το `rust`.  
Ωστόσο, η επιβάρυνση των επιδόσεων αυτής της λύσης είναι μεγάλη, καθώς υπάρχει μια ποινή απόδοσης για το `dart` που καλεί το `rust` και μια άλλη για το `quickjs` που καλεί το `dart`.

Από την άλλη πλευρά, ενώ η κοινότητα `rust` έχει [`rquickjs`](https://github.com/DelSkayn/rquickjs) τέτοιες κλήσεις στη βιβλιοθήκη `quickjs` στο `rust`.  
Ωστόσο, καλούν το `quickjs` αντί να ενσωματώσουν το `quickjs`και δεν μπορούν να χρησιμοποιηθούν για να μαγέψουν το `quickjs`.

Σε αυτή την βάση κώδικα, έχω εφαρμόσει μια νέα λύση: την άμεση τροποποίηση του πηγαίου κώδικα του `quickjs` ώστε να υποστηρίζει την επέκταση `rust`.

Πρόκειται για μια γενική λύση που μπορεί να χρησιμοποιηθεί όχι μόνο για την τροποποίηση του Kraken, αλλά και για όλα τα πλαίσια και τις βιβλιοθήκες που ενσωματώνουν το `quickjs`.

## Επίδειξη

Ο κώδικας του test.js έχει ως εξής :

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

Εκτελέστε το `./quickjs/qjs test.js`, έξοδος :

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

### Εφαρμογή της fib στη σκουριά

Η συνάρτηση fib που εισάγεται στο js προέρχεται από το `rust/src/export/fib.rs` και ο κώδικας έχει ως εξής :

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

Επί του παρόντος, η μακροεντολή της διαδικασίας `#[js]` προσθέτει απλώς μια σταθερά `fib_args_len`που προσδιορίζει τον αριθμό των επιχειρημάτων της συνάρτησης.

Μελλοντικά, η μακροεντολή διαδικασίας `./rust_macro` μπορεί να γραφτεί για να επιτρέψει την πλήρως αυτόματη εξαγωγή λειτουργιών.

### Υλοποίηση της συνάρτησης sleep στην rust

Η συνάρτηση sleep που εισάγεται στο js προέρχεται από το `rust/src/export/sleep.rs` και ο κώδικας έχει ως εξής :

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

Όπως μπορείτε να δείτε παραπάνω, όλες οι εξαγόμενες συναρτήσεις ορίζονται στον κατάλογο `./rust/src/export`. Αυτός ο κατάλογος `mod.rs` δημιουργείται αυτόματα όταν εκτελείται το `./rust/build.xsh`, εξάγοντας όλα τα αρχεία `.rs` που βρίσκονται κάτω από αυτόν.

### Ανάγνωση και επικύρωση των εισερχόμενων παραμέτρων js

Οι παράμετροι διαβάζονται και επικυρώνονται στη διεύθυνση `src/js/arg.rs` με τον ακόλουθο κώδικα :

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

Προς το παρόν ελέγχεται μόνο ο αριθμός των ορίων και διαβάζεται ο τύπος i64.

Μπορείτε να προσθέσετε αυτές τις συναρτήσεις ανάλογα με τις ανάγκες σας, δείτε τις συναρτήσεις στο [qjs_sys](https://docs.rs/qjs-sys/0.1.2/qjs_sys/) ξεκινώντας με `JS_To`.

### Μετατροπή τύπου δεδομένων από rust σε js

Η μετατροπή τύπου γίνεται στο `src/js/val.rs` με τον ακόλουθο κώδικα :

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

Μόνο τέσσερις τύποι ορίζονται για τη μετατροπή από `None`, `()`, `i64`και CString σε `js`. Μπορείτε να προσθέσετε όσους περισσότερους θέλετε.

Περισσότεροι τύποι δεδομένων μπορούν να δηλωθούν στις συναρτήσεις της [qjs_sys](https://docs.rs/qjs-sys/0.1.2/qjs_sys/) που αρχίζουν με `JS_New`.

## Περιβάλλον ανάπτυξης

Αναπτύσσω σε ένα φορητό υπολογιστή της Apple, η σκουριά χρησιμοποιεί την έκδοση 1.62.0-nightly.

Πρώτα εγκαταστήστε [το direnv](https://direnv.net), πηγαίνετε στον κατάλογο και `direnv allow` για λίγο

Εγκαταστήστε την python3, στη συνέχεια `pip3 install -r ./requirements.txt`

run `./build.xsh` για να μεταγλωττίσετε και να εκτελέσετε το demo

Από προεπιλογή, το επίσημο αποθετήριο quickjs θα κλωνοποιηθεί, αν θέλετε να τροποποιήσετε το quickjs στο αποθετήριο Kraken, πρώτα

`git clone --recursive git@github.com:openkraken/kraken.git --depth=1`

τότε κάντε τα εξής

```bash
rm -rf quickjs
ln -s ../kraken/bridge/third_party/quickjs .
```

Τέλος, επανεκτελέστε το `./build.xsh`

## Δομή καταλόγου

* `./quickjs_rust`  
  Τροποποίηση του αρχείου c του κώδικα quickjs
  
* `./quickjs_ffi`  
  Εξάγετε τις συναρτήσεις από το αρχείο κεφαλίδας `quickjs` στο `rust`
  
* `./rust`  
  Χρησιμοποιήστε το `rust` για να υλοποιήσετε τις λειτουργίες του `quickjs`
  
  * `./rust/src/qjs.rs`  
    Υλοποίηση ασύγχρονων κλήσεων. Δεδομένου ότι το `quickjs` είναι single-threaded, οι κλήσεις συναρτήσεων που αφορούν το `quckjs` γράφονται στο κύριο νήμα.
* `./rust_macro`  
  `rust` Εφαρμογή της μακροεντολής της διαδικασίας `#[js]`
  
  Στο μέλλον, δείτε [wasmedge-quickjs](https://github.com/second-state/wasmedge-quickjs/blob/70efe8520dc65636cb81b7225e2a6dae47cfad49/src/quickjs_sys/mod.rs#L122) για αυτόματη εξαγωγή συναρτήσεων rust σε συναρτήσεις js. [wasmedge-quickjs → JsFunctionTrampoline](https://github.com/second-state/wasmedge-quickjs/blob/70efe8520dc65636cb81b7225e2a6dae47cfad49/src/quickjs_sys/mod.rs#L122)
  

## Σενάρια οικοδόμησης `build.xsh`

Χωρίς άλλη καθυστέρηση, ας πάμε κατευθείαν στον πηγαίο κώδικα του σεναρίου κατασκευής `build.xsh`

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

## Επεξήγηση της αρχής

### `quickjs_rust/patch.py`

Η εκτέλεση του `./quickjs_rust/patch.py` θα κάνει κάποιες μικρές αλλαγές στον πηγαίο κώδικα του `quickjs`.

Μία από τις συναρτήσεις `JS_AddRust` χρησιμοποιείται για την έγχυση στην ενότητα rust.

Το `rust_run` εισάγεται στο `JS_ExecutePendingJob` για την κλήση ασύγχρονων συναρτήσεων.

Ένα στιγμιότυπο οθόνης με όλες τις αλλαγές παρουσιάζεται παρακάτω :

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/ep2Xgg.png)

### `quickjs_rust.h`

Από τις παραπάνω αλλαγές, μπορείτε να δείτε ότι έχουμε εισαγάγει ένα νέο αρχείο κεφαλίδας `quickjs_rust.h` με τον ακόλουθο κώδικα

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

Μπορείτε να δείτε ότι το `quickjs_rust/quickjs_rust.h` εισάγει το `quickjs_rust/js_rust_funcs.h`, το οποίο παράγεται αυτόματα από το αρχείο κεφαλίδας της λειτουργίας εξαγωγής της ρουστίκ `rust/rust.h` και δεν πρέπει να τροποποιηθεί με το χέρι.

Και το `rust/rust.h` δημιουργείται με την κλήση του cbindgen από το `./rust/build.xsh`.

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

## Προβλήματα ανάπτυξης : Υπόμνημα

### `quickjs_ffi`

Κώδικας από [quijine/main/quijine_core/src/ffi.rs](https://raw.githubusercontent.com/taskie/quijine/main/quijine_core/src/ffi.rs)

με κάποιες μικρές τροποποιήσεις, αντικαθιστώντας

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

στο

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

Τροποποίηση '. /rust/Cargo.toml' ως εξής, διατηρώντας μόνο τη staticlib

```toml
[lib]
#crate-type = ["lib", "cdylib", "staticlib"]
crate-type = ["staticlib"]
```

## Αναφορές

0. Από τη μηχανή `JS` στο πρόγραμμα εκτέλεσης `JS` [(πάνω)](https://github.com/doodlewind/blog/blob/master/source/_posts/js-engine-to-js-runtime-1.md) [(κάτω)](https://github.com/doodlewind/blog/blob/master/source/_posts/js-engine-to-js-runtime-2.md)
1. [Ανάπτυξη μιας εγγενούς μονάδας για το `QuickJS` σε C](https://github.com/quickjs-zh/QuickJS/wiki/%E4%BD%BF%E7%94%A8C%E8%AF%AD%E8%A8%80%E4%B8%BAQuickJS%E5%BC%80%E5%8F%91%E4%B8%80%E4%B8%AA%E5%8E%9F%E7%94%9F%E6%A8%A1%E5%9D%97)
2. [Χρήση του Rust για την υλοποίηση του JS API](https://wasmedge.org/book/en/dev/js/rust.html)
3. [Παραδείγματα QuickJS](https://github.com/Kozova1/quickjs-example)
4. [rust-bindgen](https://rust-lang.github.io/rust-bindgen/)
5. [Πώς να δημιουργήσετε ασύγχρονο κώδικα για το `QuickJS`](https://calbertts.medium.com/how-to-create-asynchronous-apis-for-quickjs-8aca5488bb2e)
6. [rquickjs → JS_NewPromiseCapability](https://github.com/DelSkayn/rquickjs/blob/master/core/src/context/ctx.rs#L104)
7. [wasmedge-quickjs → new_promise](https://github.com/second-state/wasmedge-quickjs/blob/8a65582265ecdd3171380feebf56b3bb8c34d183/src/quickjs_sys/mod.rs#L515)
8. [wasmedge-quickjs → JsMethod](https://github.com/second-state/wasmedge-quickjs/blob/da887752fdc9c36aca0f4b7499c5b115862ce771/src/internal_module/wasi_net_module.rs#L46)
9. [wasmedge-quickjs → κλήση](https://github.com/second-state/wasmedge-quickjs/blob/8a65582265ecdd3171380feebf56b3bb8c34d183/src/quickjs_sys/mod.rs#L756)
10. [Η απαρατήρητη παγίδα - κλειδαριές στο Rust](https://mp.weixin.qq.com/s/BKto24ItwXbeHon_LaF_0w)

## Σχετικά με το

Αυτό το έργο αποτελεί μέρος του έργου κώδικα **rmw.link ( [rmw.link](//rmw.link)** ).

![rmw.link](https://raw.githubusercontent.com/rmw-link/logo/master/rmw.red.bg.svg)