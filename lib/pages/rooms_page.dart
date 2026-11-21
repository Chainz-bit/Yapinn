import 'package:flutter/material.dart';

import '../models/room.dart';
import '../services/chat_service.dart';
import '../session.dart';
import '../theme.dart';
import '../widgets/widgets.dart';
import 'chat_page.dart';

/// Daftar semua room, realtime.
class RoomsPage extends StatefulWidget {
  const RoomsPage({super.key});

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  late final _stream = ChatService.watchRooms();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              'Halo, ${Session.userName}',
              style: const TextStyle(color: kSubtle, fontSize: 13),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Room>>(
        stream: _stream,
        builder: (context, snap) {
          if (snap.hasError) {
            debugPrint('${snap.error}');
            return const EmptyState(icon: Icons.error_outline, text: 'Gagal memuat room');
          }
          if (!snap.hasData) return const RoomListSkeleton();
          final rooms = snap.data!;
          if (rooms.isEmpty) {
            return const EmptyState(
              icon: Icons.forum_outlined,
              text: 'Belum ada room.\nBuat yang pertama!',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 96), // ruang untuk FAB
            itemCount: rooms.length,
            separatorBuilder: (_, _) => const Divider(height: 1, indent: 76),
            itemBuilder: (_, i) => RoomTile(
              key: ValueKey(rooms[i].id),
              room: rooms[i],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ChatPage(room: rooms[i])),
              ),
              onLongPress: () async {
                final newName = await showRenameRoomDialog(context, rooms[i].name);
                if (newName == null || !context.mounted) return;
                ChatService.renameRoom(rooms[i].id, newName);
                showToast(context, 'Nama room diubah menjadi "$newName"');
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final name = await showCreateRoomDialog(context);
          if (name == null || !context.mounted) return;
          ChatService.createRoom(name); // tanpa await
          showToast(context, 'Room "$name" dibuat');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
