# F3 — Buat Room

## User story
Sebagai user, aku bisa membuat room baru dan room itu langsung muncul di daftar semua orang.

## Service
```dart
static Future<void> createRoom(String name) =>
  FirebaseFirestore.instance.collection('rooms').add({
    'name': name,
    'createdBy': Session.userName,
    'createdAt': FieldValue.serverTimestamp(),
    'lastMessage': null,
    'lastSenderName': null,
    'lastMessageAt': FieldValue.serverTimestamp(), // supaya room baru langsung di paling atas
  });
```

## Wiring di `RoomsPage`
```dart
floatingActionButton: FloatingActionButton(
  onPressed: () async {
    final name = await showCreateRoomDialog(context);
    if (name == null || !context.mounted) return;
    ChatService.createRoom(name);            // tanpa await: Firestore langsung menampilkan secara lokal
    showToast(context, 'Room "$name" dibuat');
  },
  child: const Icon(Icons.add),
),
```
- Tidak auto-masuk ke room. Room cukup muncul di daftar.

## Acceptance criteria
- [ ] Room baru muncul paling atas, di device sendiri langsung dan di device lain dalam ±1 detik
- [ ] Toast "Room "…" dibuat" muncul
- [ ] Nama kosong atau Batal → tidak terjadi apa-apa
