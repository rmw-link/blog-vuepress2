# Μεταγλώττιση του kiss-ftpd ( πρόγραμμα σε γλώσσα σκουριάς ) για το Android set-top box

Το busybox έρχεται με έναν ακατάστατο κώδικα ftp, οπότε θα μεταγλωττίσετε ένα [kiss-ftpd](https://github.com/moparisthebest/kiss-ftpd) για να το χρησιμοποιήσετε στο set-top box.

Πρώτον `rustup target add aarch64-linux-android`

Στη συνέχεια, εγκαταστήστε το NDK για Android, το έκανα αυτό με το Android Studio, screenshot παρακάτω.

![](https://raw.githubusercontent.com/gcxfd/img/gh-pages/qcUqsK.png)

Φυσικά, μπορείτε επίσης να [κατεβάσετε απευθείας το NDK και να](https://developer.android.com/ndk/downloads) το [αποσυμπιέσετε](https://developer.android.com/ndk/downloads).

Το 2021, η [υψηλότερη έκδοση του NDK που υποστηρίζεται από την rust είναι η 22.1.7171670](https://github.com/mozilla/rust-android-gradle/issues/75#issuecomment-970179046), οπότε χρησιμοποιήστε πρώτα αυτή.

Τέλος, το σενάριο μεταγλώττισης έχει ως εξής.

```bash
#include rust-android.sh
```