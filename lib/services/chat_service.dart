import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/message.dart';
import '../models/room.dart';
import '../session.dart';

/// SATU-SATUNYA tempat akses Firestore di app ini.
/// Struktur data ada di specs/ (rooms/{roomId} dan rooms/{roomId}/messages/{messageId}).
class ChatService {
  static final _db = FirebaseFirestore.instance;

  // TODO(2a): Ambil daftar room secara realtime.
  // Petunjuk: _db.collection('rooms') → orderBy('lastMessageAt', descending: true)
  //           → snapshots() → map ke List<Room> pakai Room.fromDoc
  static Stream<List<Room>> watchRooms() => Stream.value(const []);

  // TODO(3a): Buat room baru.
  // Petunjuk: _db.collection('rooms').add({...}) dengan field:
  //   name, createdBy (Session.userName), createdAt (FieldValue.serverTimestamp()),
  //   lastMessage: null, lastSenderName: null,
  //   lastMessageAt (FieldValue.serverTimestamp(), supaya room baru langsung di paling atas)
  static Future<void> createRoom(String name) async {}

  // TODO(4a): Ambil pesan di satu room secara realtime, terbaru dulu.
  // Petunjuk: collection('rooms').doc(roomId).collection('messages')
  //           → orderBy('createdAt', descending: true) → limit(50)
  //           → snapshots(includeMetadataChanges: true)  ← supaya ikon jam → centang ter-update
  //           → map ke List<Message> pakai Message.fromDoc
  static Stream<List<Message>> watchMessages(String roomId) => Stream.value(const []);

  // TODO(5a): Kirim pesan + update preview room.
  // Petunjuk: pakai batch (_db.batch()) supaya dua tulisan tersimpan bersamaan:
  //   1. batch.set(dokumen baru di rooms/{roomId}/messages, {text, senderId, senderName, createdAt})
  //   2. batch.update(rooms/{roomId}, {lastMessage, lastSenderName, lastMessageAt})
  //   lalu return batch.commit();
  //   senderId/senderName dari Session, waktu pakai FieldValue.serverTimestamp().
  static Future<void> sendMessage(String roomId, String text) async {}

  // TODO(6a): Hapus pesan, lalu update preview room.
  // Petunjuk:
  //   1. delete dokumen rooms/{roomId}/messages/{messageId}
  //   2. ambil 1 pesan terbaru yang tersisa (orderBy createdAt desc, limit 1, get())
  //   3. kosong → update room {lastMessage: null, lastSenderName: null}
  //      ada    → update room dengan text & senderName pesan itu
  //   lastMessageAt JANGAN diubah supaya urutan room tidak loncat-loncat.
  static Future<void> deleteMessage(String roomId, String messageId) async {}
}
