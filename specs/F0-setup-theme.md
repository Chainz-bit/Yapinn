# F0 — Setup Project, Firebase & Theme

## Tujuan
Project Flutter siap jalan di Android dan Chrome, terhubung ke Firebase, dengan theme monokrom lembut minimalis.

## Langkah
1. `flutter create --org id.ac.polindra --platforms android,web yappin` (ganti `--org` kalau perlu).
2. Tambah package, tanpa yang lain:
   ```
   flutter pub add firebase_core cloud_firestore shared_preferences
   ```
3. Android: pastikan `minSdk` ≥ 23 di `android/app/build.gradle(.kts)`. Kalau masih `flutter.minSdkVersion` dan nilainya < 23, ganti jadi `23`.
4. `lib/firebase_options.dart` **dibuat user** via `flutterfire configure`. AI tidak boleh mengarang isinya.
5. `main.dart`:
   ```dart
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
     final savedName = await Session.loadSavedName();
     runApp(App(initialName: savedName));
   }
   ```
   `App` adalah `MaterialApp` dengan `theme: appTheme`, `debugShowCheckedModeBanner: false`, `title: 'Yappin'`, `home: NamePage(initialName: initialName)`.
6. Nama app tampil **"Yappin"** di semua tempat: `android:label` di `AndroidManifest.xml`, `<title>` dan `apple-mobile-web-app-title` di `web/index.html`, serta `name`/`short_name` di `web/manifest.json`.
7. Hapus semua kode counter bawaan `flutter create`, termasuk `test/widget_test.dart`.
8. **Kompatibilitas versi mahasiswa**: di `pubspec.yaml` set `environment: sdk: ">=3.9.0 <4.0.0"` (jangan `^3.14.0`) supaya bisa jalan di Flutter 3.47 maupun 3.50. Tetap pakai `import 'package:flutter/material.dart';`, **jangan** migrasi ke package `material_ui`/`cupertino_ui` walau ada warning deprecation di Flutter 3.50.

## Theme (`lib/theme.dart`)
Ekspor `final ThemeData appTheme` dan konstanta warna:

**Monokrom lembut**: bukan pitch black dan bukan putih murni. Referensi gaya: chat app minimalis dengan background abu sangat muda, bubble sendiri gelap, bubble orang lain off-white.

| Konstanta | Nilai | Dipakai untuk |
|---|---|---|
| `kInk` | `#424242` | warna gelap utama: tombol, FAB, avatar, bubble sendiri, ikon kirim |
| `kText` | `#2E2E2E` | teks utama |
| `kSubtle` | `#8E8E8E` | teks sekunder (waktu, preview, hint, nama pengirim) |
| `kOnInk` | `#F5F5F5` | teks/ikon di atas `kInk` |
| `kBg` | `#F5F5F5` | background scaffold (halaman nama & daftar room) |
| `kChatBg` | `#ECECEC` | background area pesan di halaman chat |
| `kSurface` | `#FAFAFA` | AppBar, input bar, bubble orang lain, dialog, bottom sheet |
| `kField` | `#EAEAEA` | isi TextField (pill abu, tanpa border) |
| `kLine` | `#E4E4E4` | divider, border tipis |

**Dilarang** memakai `Colors.black` atau `Colors.white` langsung. Selalu pakai konstanta di atas.

- `useMaterial3: true`, `scaffoldBackgroundColor: kBg`
- `colorScheme: ColorScheme.light(primary: kInk, onPrimary: kOnInk, surface: kSurface, onSurface: kText, outline: kLine)`
- `textTheme`: warna default `kText` (`bodyColor` & `displayColor`)
- `AppBarTheme`: background `kSurface`, foreground `kText`, `elevation: 0`, `scrolledUnderElevation: 0`, `centerTitle: false`, judul `fontSize 20, w600`
- `FilledButton`: background `kInk`, teks `kOnInk`, radius 14, tinggi minimal 52
- `FloatingActionButton`: background `kInk`, ikon `kOnInk`, `elevation: 0`, bentuk lingkaran
- `InputDecorationTheme`: `filled: true`, `fillColor: kField`, **tanpa border** (`OutlineInputBorder(borderSide: BorderSide.none)`), radius 14, hint warna `kSubtle`
- `DialogTheme` & `BottomSheetTheme`: background `kSurface`, `surfaceTintColor: Colors.transparent`
- `DividerTheme`: warna `kLine`, thickness 1
- `ProgressIndicatorTheme`: warna `kInk`
- Font: default (jangan pakai google_fonts)

## `lib/utils.dart`
```dart
String formatTime(DateTime? t)
```
- `null` → `''`
- Hari ini → `HH:mm` (pakai `padLeft(2, '0')`, tanpa package `intl`)
- Selain itu → `dd/MM`

## Acceptance criteria
- [ ] `flutter run -d chrome` dan di Android sama-sama jalan tanpa error Firebase
- [ ] Tidak ada `Colors.black`/`Colors.white` atau warna non-grayscale di seluruh app
- [ ] `flutter analyze` tanpa error
