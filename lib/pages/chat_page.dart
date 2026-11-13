import 'package:flutter/material.dart';

import '../models/room.dart';
import '../theme.dart';
import '../widgets/widgets.dart';

/// Halaman chat satu room (diisi di F4).
class ChatPage extends StatelessWidget {
  final Room room;

  const ChatPage({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            InitialAvatar(name: room.name, radius: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                room.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
      body: const ColoredBox(color: kChatBg, child: SizedBox.expand()),
    );
  }
}
