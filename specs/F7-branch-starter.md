# F7 — Branch `app` vs `main` (Starter Mahasiswa)

## Tujuan
- `app` → aplikasi **lengkap** (hasil F0–F6 + C). Untuk demo & kunci jawaban.
- `main` → **starter** untuk mahasiswa (default branch, yang ter-clone otomatis).

Yang **sudah jadi** di starter: `pubspec.yaml` (semua package), `firebase_options.dart`, theme, utils, `Session`, models, **semua komponen di `lib/widgets/`**, `NamePage`, dan kerangka `RoomsPage`/`ChatPage` (AppBar, layout, import sudah ada).

Yang **dikosongkan** (TODO), hanya bagian koneksi Firebase dan menyambungkan data ke komponen:

| TODO | File | Tugas | Hasil yang terlihat |
|---|---|---|---|
| 1 | `main.dart` | `Firebase.initializeApp` | App terhubung ke Firebase |
| 2a | `chat_service.dart` | `watchRooms()` | |
| 2b | `rooms_page.dart` | `StreamBuilder` → `RoomListSkeleton` / `EmptyState` / `RoomTile` | Daftar room realtime |
| 3a | `chat_service.dart` | `createRoom()` | |
| 3b | `rooms_page.dart` | FAB → `showCreateRoomDialog` → `createRoom` → `showToast` | Bisa buat room |
| 4a | `chat_service.dart` | `watchMessages()` | |
| 4b | `chat_page.dart` | `StreamBuilder` → `ChatSkeleton` / `EmptyState` / `MessageBubble` | Pesan realtime |
| 5a | `chat_service.dart` | `sendMessage()` | |
| 5b | `chat_page.dart` | `MessageInput(onSend: ...)` | Bisa kirim pesan |
| 6a | `chat_service.dart` | `deleteMessage()` | |
| 6b | `chat_page.dart` | `_confirmDelete` → `showDeleteMessageSheet` → `deleteMessage` → `showToast` | Bisa hapus pesan |

## Alur git
```bash
# 0. awal: flutter create + docs, commit di main
git checkout -b app          # 1. kerjakan F0–F6 + C di sini, commit per fitur
# ... semua fitur selesai & dites ...
git checkout main
git merge app                # 2. fast-forward, main = app lengkap
# 3. kosongkan bagian TODO (lihat di bawah), lalu:
git commit -am "chore: starter praktikum"
git push -u origin app main  # 4. default branch GitHub = main
```

## Aturan mengosongkan
**Starter WAJIB tetap bisa di-run tanpa error** (warning "unused import/field" boleh).

### `lib/main.dart`
```dart
// TODO(1): Inisialisasi Firebase di sini.
// Petunjuk: await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
```

### `lib/services/chat_service.dart`
Signature tetap, body dikosongkan, beri komentar petunjuk (query apa, field apa), **bukan** kode jadi:
```dart
// TODO(2a): Ambil daftar room secara realtime.
// Petunjuk: collection('rooms') → orderBy('lastMessageAt', descending: true)
//           → snapshots() → map ke List<Room> pakai Room.fromDoc
static Stream<List<Room>> watchRooms() => Stream.value(const []);

// TODO(3a) ... createRoom      → static Future<void> createRoom(String name) async {}
// TODO(4a) ... watchMessages   → Stream.value(const []); petunjuk sebut includeMetadataChanges: true
// TODO(5a) ... sendMessage     → async {}; petunjuk sebut batch
// TODO(6a) ... deleteMessage   → async {}; petunjuk sebut update preview room
```

### `lib/pages/rooms_page.dart`
- Body diganti placeholder yang bisa jalan, dengan TODO berisi petunjuk komponen mana yang dipakai per state:
```dart
// TODO(2b): Ganti dengan StreamBuilder<List<Room>> dari ChatService.watchRooms().
//   error → EmptyState(icon: Icons.error_outline, ...)
//   loading (belum ada data) → RoomListSkeleton()
//   kosong → EmptyState(icon: Icons.forum_outlined, ...)
//   ada data → ListView.separated + RoomTile(room: ..., onTap: buka ChatPage)
body: const EmptyState(icon: Icons.construction_outlined, text: 'TODO 2b\nTampilkan daftar room di sini'),
```
- FAB tetap ada, `onPressed` berisi `// TODO(3b)` + petunjuk.

### `lib/pages/chat_page.dart`
- Area pesan diganti `EmptyState(... 'TODO 4b\nTampilkan pesan di sini')` di dalam `ColoredBox(kChatBg)`.
- `MessageInput(onSend: (text) { /* TODO(5b) */ })`.
- `_confirmDelete(Message m)` tetap ada dengan body `// TODO(6b)` + petunjuk (tidak dipakai sampai 4b selesai, warning boleh).

### File lain
- **Tidak diubah**: `lib/widgets/*`, models, session, theme, utils, `NamePage`, `pubspec.yaml`, `firebase_options.dart`.
- **Hapus** `CLAUDE.md` dari `main`. Folder `specs/` tetap ada sebagai referensi mahasiswa.
- **Ganti** `README.md` dengan versi mahasiswa (di bawah).

## README.md (versi `main`)
```markdown
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

Detail tiap fitur ada di folder `specs/`.

## Ngintip jawaban
`git checkout app` (usahakan setelah mencoba sendiri dulu ya 😄)
```

## Acceptance criteria
- [ ] `git clone` (tanpa `-b`) → dapat branch `main` (starter)
- [ ] Di `main`: `flutter run` jalan tanpa error. Halaman nama → halaman room dengan placeholder TODO → FAB tidak melakukan apa-apa
- [ ] Di `main`: mengisi semua TODO sesuai petunjuk menghasilkan perilaku yang sama dengan `app`
- [ ] `git checkout app` → aplikasi lengkap langsung jalan
