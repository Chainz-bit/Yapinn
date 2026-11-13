import 'package:flutter/material.dart';

import '../models/room.dart';
import '../theme.dart';
import '../utils.dart';
import 'initial_avatar.dart';

/// Satu baris di daftar room.
class RoomTile extends StatelessWidget {
  final Room room;
  final VoidCallback onTap;

  const RoomTile({super.key, required this.room, required this.onTap});

  /// Ganti teks dengan halus (fade + sedikit perubahan tinggi).
  Widget _smooth(Widget child) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SizeTransition(
          sizeFactor: animation,
          alignment: Alignment.topLeft,
          child: child,
        ),
      ),
      // Teks lama & baru ditumpuk rata kiri selama transisi.
      // `?current` = masukkan current hanya kalau tidak null.
      layoutBuilder: (current, previous) => Stack(
        alignment: Alignment.centerLeft,
        children: [...previous, ?current],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final time = formatTime(room.lastMessageAt);
    final hasMessage = room.lastMessage != null;
    final preview = hasMessage
        ? '${room.lastSenderName}: ${room.lastMessage}'
        : 'Belum ada pesan';

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            InitialAvatar(name: room.name),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          room.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _smooth(
                        Text(
                          time,
                          key: ValueKey(time),
                          style: const TextStyle(color: kSubtle, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  _smooth(
                    Text(
                      preview,
                      key: ValueKey(preview),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: kSubtle,
                        fontSize: 14,
                        fontStyle: hasMessage ? FontStyle.normal : FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
