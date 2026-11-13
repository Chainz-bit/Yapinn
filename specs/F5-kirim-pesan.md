# F5 — Kirim Pesan (+ Update Preview Room)

## User story
Sebagai user, aku mengirim pesan. Pesan itu langsung muncul (pop + ikon jam), berubah jadi centang setelah sampai server, dan room naik ke paling atas daftar dengan preview pesanku.

## Service
Pakai **batch** supaya pesan & preview room tersimpan bersamaan:
```dart
static Future<void> sendMessage(String roomId, String text) {
  final db = FirebaseFirestore.instance;
  final roomRef = db.collection('rooms').doc(roomId);
  final batch = db.batch();

  batch.set(roomRef.collection('messages').doc(), {
    'text': text,
    'senderId': Session.userId,
    'senderName': Session.userName,
    'createdAt': FieldValue.serverTimestamp(),
  });
  batch.update(roomRef, {
    'lastMessage': text,
    'lastSenderName': Session.userName,
    'lastMessageAt': FieldValue.serverTimestamp(),
  });

  return batch.commit();
}
```

## Wiring di `ChatPage`
```dart
MessageInput(onSend: (text) => ChatService.sendMessage(widget.room.id, text)),
```
- Jangan `await` di UI. `MessageInput` sudah mengosongkan input + haptic (lihat `C-komponen.md`).

## Acceptance criteria
- [ ] Pesan langsung tampil di device pengirim dengan animasi pop + ikon jam, lalu jadi centang
- [ ] Muncul di device lain dalam ±1 detik
- [ ] Input langsung kosong setelah kirim, pesan kosong tidak terkirim
- [ ] Di daftar room (device lain), room ini naik ke atas dengan preview "{nama}: {pesan}"
