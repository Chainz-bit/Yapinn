import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  final String id;
  final String name;
  final String? lastMessage;
  final String? lastSenderName;
  final DateTime? lastMessageAt;

  Room({
    required this.id,
    required this.name,
    this.lastMessage,
    this.lastSenderName,
    this.lastMessageAt,
  });

  factory Room.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Room(
      id: doc.id,
      name: data['name'] ?? '',
      lastMessage: data['lastMessage'],
      lastSenderName: data['lastSenderName'],
      // Bisa null sesaat (serverTimestamp belum balik dari server)
      lastMessageAt: (data['lastMessageAt'] as Timestamp?)?.toDate(),
    );
  }
}
