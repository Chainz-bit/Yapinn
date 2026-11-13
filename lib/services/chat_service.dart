import 'package:cloud_firestore/cloud_firestore.dart';

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
}
