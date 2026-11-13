# F2 — Daftar Room (Realtime)

## User story
Sebagai user, aku melihat semua room. Room yang paling baru ada chatnya otomatis naik ke atas, lengkap dengan potongan pesan terakhir, tanpa refresh.

## Model `lib/models/room.dart` (sudah jadi di kedua branch)
```dart
class Room {
  final String id;
  final String name;
  final String? lastMessage;
  final String? lastSenderName;
  final DateTime? lastMessageAt;

  factory Room.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc);
}
```
- Timestamp: `(data['lastMessageAt'] as Timestamp?)?.toDate()`. Bisa `null` sesaat (serverTimestamp belum balik dari server), jadi wajib aman null.

## Service
```dart
static Stream<List<Room>> watchRooms() =>
  FirebaseFirestore.instance
    .collection('rooms')
    .orderBy('lastMessageAt', descending: true)
    .snapshots()
    .map((s) => s.docs.map(Room.fromDoc).toList());
```

## Halaman `RoomsPage`
- AppBar: judul **"Room"**, di `actions` teks kecil `kSubtle` "Halo, {Session.userName}" (padding kanan 16).
- Body: menyambungkan stream ke komponen (lihat `C-komponen.md`):
```dart
StreamBuilder<List<Room>>(
  stream: ChatService.watchRooms(),
  builder: (context, snap) {
    if (snap.hasError) {
      debugPrint('${snap.error}');
      return const EmptyState(icon: Icons.error_outline, text: 'Gagal memuat room');
    }
    if (!snap.hasData) return const RoomListSkeleton();
    final rooms = snap.data!;
    if (rooms.isEmpty) {
      return const EmptyState(icon: Icons.forum_outlined, text: 'Belum ada room.\nBuat yang pertama!');
    }
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 96), // ruang untuk FAB
      itemCount: rooms.length,
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 76),
      itemBuilder: (_, i) => RoomTile(
        room: rooms[i],
        onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => ChatPage(room: rooms[i]))),
      ),
    );
  },
)
```
- FAB `Icons.add` → F3.

## Acceptance criteria
- [ ] Saat pertama dibuka tampil skeleton berdenyut, lalu daftar room
- [ ] Room baru dari device lain muncul tanpa refresh
- [ ] Kirim pesan di room X (dari device mana pun) → room X pindah ke paling atas, preview & waktu berganti dengan animasi halus
- [ ] Tidak crash saat `lastMessageAt` null sesaat
