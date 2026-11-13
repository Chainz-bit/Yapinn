import 'package:cloud_firestore/cloud_firestore.dart';

import '../session.dart';

class Message {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final DateTime? createdAt; // null sesaat setelah kirim (serverTimestamp pending)
  final bool isPending; // true = belum sampai server

  Message({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    this.createdAt,
    this.isPending = false,
  });

  bool get isMine => senderId == Session.userId;

  factory Message.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Message(
      id: doc.id,
      text: data['text'] ?? '',
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      isPending: doc.metadata.hasPendingWrites,
    );
  }
}
