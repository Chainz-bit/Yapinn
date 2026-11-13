# F6 — Hapus Pesan Sendiri

## User story
Sebagai user, aku bisa menghapus pesanku sendiri, dan pesan itu hilang di semua device.

> Tanpa security rules. Pembatasan "hanya pesan sendiri" cukup di level UI (`onLongPress` hanya untuk `isMine`).

## Service
```dart
static Future<void> deleteMessage(String roomId, String messageId) async {
  final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
  await roomRef.collection('messages').doc(messageId).delete();

  // Perbarui preview room dengan pesan terakhir yang tersisa
  final latest = await roomRef.collection('messages')
      .orderBy('createdAt', descending: true).limit(1).get();

  if (latest.docs.isEmpty) {
    await roomRef.update({'lastMessage': null, 'lastSenderName': null});
  } else {
    final d = latest.docs.first.data();
    await roomRef.update({'lastMessage': d['text'], 'lastSenderName': d['senderName']});
  }
}
```
- `lastMessageAt` **tidak diubah** supaya urutan room tidak loncat-loncat.

## Wiring di `ChatPage`
```dart
Future<void> _confirmDelete(Message m) async {
  final ok = await showDeleteMessageSheet(context);
  if (!ok || !mounted) return;
  ChatService.deleteMessage(widget.room.id, m.id);   // tanpa await
  showToast(context, 'Pesan dihapus');
}
```

## Acceptance criteria
- [ ] Long-press pesan sendiri → haptic + bottom sheet; pesan orang lain → tidak terjadi apa-apa
- [ ] Pesan hilang di semua device dalam ±1 detik, toast "Pesan dihapus" muncul
- [ ] Hapus pesan terakhir → preview di daftar room berganti ke pesan sebelumnya
- [ ] Hapus semua pesan → preview kembali "Belum ada pesan"
