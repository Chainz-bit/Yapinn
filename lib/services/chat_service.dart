import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/room.dart';

/// SATU-SATUNYA tempat akses Firestore di app ini.
class ChatService {
  static final _db = FirebaseFirestore.instance;

  /// Daftar room realtime, yang paling baru ada pesan di atas.
  static Stream<List<Room>> watchRooms() => _db
      .collection('rooms')
      .orderBy('lastMessageAt', descending: true)
      .snapshots()
      .map((s) => s.docs.map(Room.fromDoc).toList());
}
