# Yappin — Praktikum Realtime Chat (Flutter + Firebase)

## Persiapan
1. `flutter pub get`
2. `flutter run` (emulator/HP) atau `flutter run -d chrome`
3. Harus muncul halaman "Yappin". Halaman room berisi tulisan TODO itu normal.

## Yang sudah disiapkan
Semua komponen UI ada di `lib/widgets/` (cukup `import '../widgets/widgets.dart';`).
Tugasmu: ambil data dari Firebase di `lib/services/chat_service.dart`, lalu sambungkan ke komponen di halaman.

## Tugas
| TODO | File | Hasil |
|---|---|---|
| 1 | lib/main.dart | Terhubung ke Firebase |
| 2a, 2b | chat_service.dart, rooms_page.dart | Daftar room realtime |
| 3a, 3b | chat_service.dart, rooms_page.dart | Buat room |
| 4a, 4b | chat_service.dart, chat_page.dart | Pesan realtime |
| 5a, 5b | chat_service.dart, chat_page.dart | Kirim pesan |
| 6a, 6b | chat_service.dart, chat_page.dart | Hapus pesan |

## Ngintip jawaban
`git checkout app` (usahakan setelah mencoba sendiri dulu ya 😄)
