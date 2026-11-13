# C — Komponen UI (siap pakai)

Semua komponen **sudah jadi di kedua branch** (`app` & `main`). Halaman cukup:
```dart
import '../widgets/widgets.dart'; // satu import untuk semua komponen
```
lalu mengoper data dari stream/Firestore ke komponen. Komponen **tidak boleh** memanggil `ChatService` atau Firestore. Data masuk lewat parameter, aksi keluar lewat callback.

Semua warna dari `lib/theme.dart` (lihat F0). Animasi hanya pakai bawaan Flutter (tanpa package).

## Daftar file
```
lib/widgets/
  widgets.dart          # barrel: export semua file di bawah
  pulse.dart            # Pulse
  skeletons.dart        # RoomListSkeleton, ChatSkeleton
  empty_state.dart      # EmptyState
  initial_avatar.dart   # InitialAvatar
  room_tile.dart        # RoomTile
  message_bubble.dart   # MessageBubble
  message_input.dart    # MessageInput
  dialogs.dart          # showCreateRoomDialog, showDeleteMessageSheet, showToast
```

---

## `Pulse({required Widget child})`
Efek "bernapas" untuk skeleton loading.
- `AnimationController` 900 ms, `repeat(reverse: true)`, opacity 0.45 → 1.0 (`FadeTransition`).

## `RoomListSkeleton()`
Loading state daftar room.
- 6 baris dibungkus `Pulse`, tiap baris padding sama dengan `RoomTile`:
  - lingkaran 48×48 `kField`
  - dua bar `kField` radius 6: 140×12 lalu (jarak 8) 220×10
- Tidak bisa di-scroll (`NeverScrollableScrollPhysics`).

## `ChatSkeleton()`
Loading state halaman chat.
- 6 bar berbentuk bubble (tinggi 38, radius 20), selang-seling kiri/kanan, lebar bervariasi (160, 220, 120, 200, 140, 180), warna `kField`, dibungkus `Pulse`, rata bawah.

## `EmptyState({required IconData icon, required String text})`
Dipakai untuk kosong **dan** error.
- Tengah layar: ikon 48 `kSubtle`, jarak 12, teks `kSubtle` rata tengah `fontSize 14`.
- Animasi masuk: `TweenAnimationBuilder` 350 ms, opacity 0→1 + geser naik 12 px → 0, `Curves.easeOut`.

## `InitialAvatar({required String name, double radius = 24})`
- `CircleAvatar` background `kInk`, huruf pertama `name` (uppercase, `?` kalau kosong), warna `kOnInk`, `w600`.

## `RoomTile({required Room room, required VoidCallback onTap})`
- `InkWell` + padding horizontal 16, vertikal 12, `Row`:
  - `InitialAvatar(name: room.name)`
  - jarak 12, `Expanded` `Column`:
    - Baris 1: nama room (`w600`, `fontSize 16`, 1 baris ellipsis) + `Spacer` + waktu `formatTime(room.lastMessageAt)` (`kSubtle`, `fontSize 12`)
    - Baris 2 (jarak 4): preview, 1 baris ellipsis, `kSubtle`, `fontSize 14`
      - `lastMessage == null` → "Belum ada pesan" (italic)
      - selain itu → "{lastSenderName}: {lastMessage}"
- **Animasi realtime**: preview & waktu dibungkus `AnimatedSwitcher` 250 ms (fade + `SizeTransition` ringan) dengan `key: ValueKey(teksnya)`. Saat ada pesan baru, preview "berganti" halus, bukan lompat.

## `MessageBubble({required Message message, VoidCallback? onLongPress})`
- `Align` kanan (`isMine`) / kiri, lebar maks 75% layar, margin vertikal 3.
- `GestureDetector(onLongPress)`: sebelum memanggil callback, `HapticFeedback.selectionClick()`. Kalau `onLongPress == null`, tidak ada aksi.
- Padding `fromLTRB(14, 10, 14, 8)`, tanpa shadow, tanpa border.

| | Pesan sendiri | Pesan orang lain |
|---|---|---|
| Background | `kInk` | `kSurface` |
| Teks (`fontSize 15`, `height 1.3`) | `kOnInk` | `kText` |
| Radius | 20, kecuali bawah-kanan 6 | 20, kecuali bawah-kiri 6 |
| Nama pengirim | tidak ditampilkan | di atas teks, `fontSize 12, w600`, `kSubtle` |
| Baris bawah (rata kanan, `fontSize 10`) | waktu + **ikon status** | waktu saja |
| Warna baris bawah | `kOnInk` opacity 60% | `kSubtle` |

- Waktu: `formatTime(message.createdAt ?? DateTime.now())`.
- **Ikon status kirim** (hanya pesan sendiri, ukuran 12, jarak 4 dari waktu):
  - `message.isPending` → `Icons.schedule` (sedang dikirim)
  - selain itu → `Icons.check` (sudah sampai server)
  - Dibungkus `AnimatedSwitcher` 200 ms (scale + fade) supaya pergantian jam → centang terasa "pop".
- **Animasi pop saat pesan baru**: hanya kalau pesan masih segar (`createdAt == null` **atau** umur < 5 detik):
  - `TweenAnimationBuilder<double>` 0→1, 280 ms, `Curves.easeOutBack`
  - `Transform.scale(0.85 + 0.15 * v)` + `Opacity(v.clamp(0, 1))`
  - `alignment`: `Alignment.bottomRight` (sendiri) / `Alignment.bottomLeft` (orang lain)
  - Pesan lama tidak dianimasikan (supaya tidak "meledak" semua saat buka room atau scroll).

## `MessageInput({required ValueChanged<String> onSend})`
- `StatefulWidget` dengan `TextEditingController`, rebuild saat teks berubah (listener).
- Container `kSurface`, border atas `kLine`, padding `fromLTRB(12, 8, 8, 8)`, dibungkus `SafeArea(top: false)`.
- `Row`:
  - `Expanded` `TextField`: hint "Tulis pesan…", `minLines 1`, `maxLines 4`, `textCapitalization: sentences`, pill radius 24, isi `kField`, tanpa border, `contentPadding` h16 v10, `onSubmitted` = kirim.
  - Jarak 8, tombol kirim: `IconButton.filled` ikon `Icons.arrow_upward`, background `kInk`, ikon `kOnInk`.
    - Teks kosong → tombol disabled, dibungkus `AnimatedScale` (0.85) + `AnimatedOpacity` (0.4), 150 ms. Ada teks → skala 1, opacity 1.
- Kirim: `trim()`. Kosong → abaikan. Ada isi → `HapticFeedback.lightImpact()`, `onSend(text)`, lalu **langsung** `controller.clear()`.

## `Future<String?> showCreateRoomDialog(BuildContext context)`
- `AlertDialog` radius 20, judul **"Room baru"**, `TextField` `autofocus`, hint "Nama room", `maxLength 30`, `onSubmitted` = Buat.
- Actions: `TextButton` **"Batal"** (`kSubtle`) → `null`; `FilledButton` **"Buat"** → nama `trim()` (kalau kosong, return `null`).

## `Future<bool> showDeleteMessageSheet(BuildContext context)`
- `showModalBottomSheet`, radius atas 20, background `kSurface`, ada drag handle kecil (36×4, `kLine`).
- `ListTile` `Icons.delete_outline` **"Hapus pesan"** → `true`; `ListTile` `Icons.close` **"Batal"** → `false`. Ditutup tanpa memilih → `false`.

## `void showToast(BuildContext context, String text)`
- `ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(...)`
- `SnackBar` `behavior: floating`, background `kInk`, teks `kOnInk`, radius 14, margin 16, durasi 2 detik, `elevation 0`.

## Acceptance criteria
- [ ] Tidak ada komponen yang import `cloud_firestore` atau `chat_service.dart` (kecuali model yang memang butuh tipe Firestore)
- [ ] Pesan sendiri: muncul dengan pop + ikon jam, lalu berubah jadi centang setelah tersimpan di server
- [ ] Buka room lama: bubble lama tidak ikut beranimasi
- [ ] Skeleton tampil saat loading, `EmptyState` tampil saat kosong/error
- [ ] Tombol kirim redup & tidak bisa ditekan saat input kosong
