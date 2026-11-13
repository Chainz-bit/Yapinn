# F1 — Input Nama (Session)

## User story
Sebagai user, aku mengisi nama sekali supaya pesanku punya identitas, tanpa perlu login.

## `lib/session.dart`
```dart
class Session {
  static String userId = '';
  static String userName = '';

  /// Baca 'userName' & 'userId' dari SharedPreferences.
  /// Isi field statis kalau ada. Return nama tersimpan (atau null).
  static Future<String?> loadSavedName();

  /// Simpan nama. Kalau userId masih kosong, buat baru:
  /// '${DateTime.now().microsecondsSinceEpoch}${Random().nextInt(9999)}'
  /// Simpan keduanya ke SharedPreferences dan field statis.
  static Future<void> save(String name);
}
```
- `userId` **tidak berubah** walau nama diganti. Dipakai untuk menentukan bubble kiri/kanan, jadi harus tetap sama setelah restart.

## UI `NamePage({String? initialName})`
- Body di tengah layar, padding horizontal 24, max lebar 400 (pakai `ConstrainedBox`, supaya rapi di Chrome).
- Susunan vertikal:
  1. Judul **"Yappin"**, `fontSize 36, w800`, `letterSpacing -1`
  2. Subjudul abu: "Masukkan nama untuk mulai ngobrol"
  3. `TextField` (hint "Nama kamu", `maxLength: 20`, `textCapitalization: words`, prefill `initialName`, `onSubmitted` = submit)
  4. `FilledButton` lebar penuh: **"Masuk"**
- Tombol disabled kalau nama (setelah `trim()`) kosong.

## Perilaku
1. Tekan "Masuk" → `await Session.save(name.trim())` → `Navigator.pushReplacement` ke `RoomsPage`.
2. Kalau sudah pernah isi nama, field langsung terisi (tidak auto-skip, user tetap tekan "Masuk").

## Acceptance criteria
- [ ] Nama kosong/spasi tidak bisa submit
- [ ] Setelah restart app, nama terisi otomatis dan `userId` sama seperti sebelumnya
- [ ] Bisa masuk dengan Enter di keyboard
