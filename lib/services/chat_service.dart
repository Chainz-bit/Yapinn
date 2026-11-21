import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/message.dart';
import '../models/room.dart';
import '../session.dart';

/// SATU-SATUNYA tempat akses Firestore di app ini.
/// Struktur data Firestore:
///   rooms/{roomId}
///     name, createdBy, createdAt, lastMessage, lastSenderName, lastMessageAt
///   rooms/{roomId}/messages/{messageId}
///     text, senderId, senderName, createdAt
class ChatService {
  static final _db = FirebaseFirestore.instance;

  static Stream<List<Room>> watchRooms() => _db
      .collection('rooms')
      .orderBy('lastMessageAt', descending: true)
      .snapshots()
      .map((s) => s.docs.map(Room.fromDoc).toList());

  static Future<void> createRoom(String name) => _db.collection('rooms').add({
        'name': name,
        'createdBy': Session.userName,
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': null,
        'lastSenderName': null,
        'lastMessageAt': FieldValue.serverTimestamp(), // supaya room baru langsung di paling atas
        'messageCount': 0,
      });

  /// Ganti nama room.
  static Future<void> renameRoom(String roomId, String newName) =>
      _db.collection('rooms').doc(roomId).update({'name': newName});

  static Stream<List<Message>> watchMessages(String roomId) => _db
      .collection('rooms')
      .doc(roomId)
      .collection('messages')
      .orderBy('createdAt', descending: true)
      .limit(50) // hemat kuota baca
      .snapshots(includeMetadataChanges: true) // supaya status jam → centang ter-update
      .map((s) => s.docs.map(Message.fromDoc).toList());

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
      'messageCount': FieldValue.increment(1),
    });

    return batch.commit();
  }

  static Future<void> deleteMessage(String roomId, String messageId) async {
    final roomRef = _db.collection('rooms').doc(roomId);
    await roomRef.collection('messages').doc(messageId).delete();

    final latest = await roomRef
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    final updateData = <String, dynamic>{
      'messageCount': FieldValue.increment(-1),
    };

    // lastMessageAt sengaja tidak diubah supaya urutan room tidak loncat-loncat.
    if (latest.docs.isEmpty) {
      updateData['lastMessage'] = null;
      updateData['lastSenderName'] = null;
    } else {
      final d = latest.docs.first.data();
      updateData['lastMessage'] = d['text'];
      updateData['lastSenderName'] = d['senderName'];
    }

    await roomRef.update(updateData);
  }
}
