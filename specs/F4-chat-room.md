# F4 — Halaman Chat: Pesan Realtime + Bubble

## User story
Sebagai user, aku masuk ke room dan melihat percakapan realtime. Banyak user bisa berada di room yang sama bersamaan. Pesanku di kanan, pesan orang lain di kiri, dan aku bisa melihat apakah pesanku sudah terkirim.

> Tidak ada konsep "member" atau "join". Siapa pun yang membuka room otomatis melihat & bisa kirim pesan.

## Model `lib/models/message.dart` (sudah jadi di kedua branch)
```dart
class Message {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final DateTime? createdAt;   // null sesaat setelah kirim (serverTimestamp pending)
  final bool isPending;        // true = belum sampai server

  bool get isMine => senderId == Session.userId;

  factory Message.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc);
  // isPending: doc.metadata.hasPendingWrites
}
```

## Service
```dart
static Stream<List<Message>> watchMessages(String roomId) =>
  FirebaseFirestore.instance
    .collection('rooms').doc(roomId).collection('messages')
    .orderBy('createdAt', descending: true)    // terbaru dulu
    .limit(50)                                 // hemat kuota baca
    .snapshots(includeMetadataChanges: true)   // supaya status jam → centang ter-update
    .map((s) => s.docs.map(Message.fromDoc).toList());
```

## Halaman `ChatPage({required Room room})`
- AppBar: `InitialAvatar(name: room.name, radius: 18)` + jarak 10 + nama room (`w600`). Tombol back default.
- Body `Column`:
```dart
Expanded(
  child: ColoredBox(
    color: kChatBg,
    child: StreamBuilder<List<Message>>(
      stream: ChatService.watchMessages(widget.room.id),
      builder: (context, snap) {
        if (snap.hasError) {
          debugPrint('${snap.error}');
          return const EmptyState(icon: Icons.error_outline, text: 'Gagal memuat pesan');
        }
        if (!snap.hasData) return const ChatSkeleton();
        final messages = snap.data!;
        if (messages.isEmpty) {
          return const EmptyState(icon: Icons.waving_hand_outlined, text: 'Belum ada pesan.\nSapa duluan!');
        }
        return ListView.builder(
          reverse: true,                       // + data descending = terbaru di bawah
          padding: const EdgeInsets.all(12),
          itemCount: messages.length,
          itemBuilder: (_, i) {
            final m = messages[i];
            return MessageBubble(
              key: ValueKey(m.id),
              message: m,
              onLongPress: m.isMine ? () => _confirmDelete(m) : null, // F6
            );
          },
        );
      },
    ),
  ),
),
MessageInput(onSend: ...), // F5
```
- Simpan stream di `initState` (`late final _stream = ChatService.watchMessages(...)`) supaya tidak membuat listener baru setiap rebuild.

## Acceptance criteria
- [ ] Skeleton tampil saat loading, lalu pesan
- [ ] 2 device di room yang sama → pesan dari satu device muncul di device lain tanpa refresh, dengan animasi pop
- [ ] Bubble kiri/kanan benar, juga setelah app di-restart (karena `userId` tersimpan)
- [ ] Pesan terbaru selalu di paling bawah
- [ ] Tidak crash saat `createdAt` null
