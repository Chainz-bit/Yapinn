import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/message.dart';
import '../models/room.dart';
import '../session.dart';

/// SATU-SATUNYA tempat akses Firestore di app ini.
class ChatService {
  static final _db = FirebaseFirestore.instance;

  /// Daftar room realtime, yang paling baru ada pesan di atas.
  static Stream<List<Room>> watchRooms() => _db
      .collection('rooms')
      .orderBy('lastMessageAt', descending: true)
      .snapshots()
      .map((s) => s.docs.map(Room.fromDoc).toList());

  /// Buat room baru.
  static Future<void> createRoom(String name) => _db.collection('rooms').add({
        'name': name,
        'createdBy': Session.userName,
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': null,
        'lastSenderName': null,
        'lastMessageAt': FieldValue.serverTimestamp(), // supaya room baru langsung di paling atas
      });

  /// Pesan realtime di satu room, terbaru dulu.
  static Stream<List<Message>> watchMessages(String roomId) => _db
      .collection('rooms')
      .doc(roomId)
      .collection('messages')
      .orderBy('createdAt', descending: true)
      .limit(50) // hemat kuota baca
      .snapshots(includeMetadataChanges: true) // supaya status jam → centang ter-update
      .map((s) => s.docs.map(Message.fromDoc).toList());

  /// Kirim pesan + update preview room dalam satu batch.
  static Future<void> sendMessage(String roomId, String text) {
    final roomRef = _db.collection('rooms').doc(roomId);
    final batch = _db.batch();

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
}
