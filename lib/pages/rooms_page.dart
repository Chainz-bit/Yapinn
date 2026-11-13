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
      // TODO(2b): Ganti dengan StreamBuilder<List<Room>> dari ChatService.watchRooms().
      //   Simpan stream-nya sekali sebagai field (late final), jangan dibuat ulang tiap build.
      //   error → EmptyState(icon: Icons.error_outline, text: 'Gagal memuat room')
      //   loading (belum ada data) → RoomListSkeleton()
      //   kosong → EmptyState(icon: Icons.forum_outlined, text: 'Belum ada room.\nBuat yang pertama!')
      //   ada data → ListView.separated + RoomTile(room: ..., onTap: buka ChatPage(room: ...))
      //              separator: Divider(height: 1, indent: 76), padding bawah 96 (ruang FAB)
      body: const EmptyState(
        icon: Icons.construction_outlined,
        text: 'TODO 2b\nTampilkan daftar room di sini',
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO(3b): Buat room baru.
          // Petunjuk:
          //   final name = await showCreateRoomDialog(context);   (jadikan fungsi ini async)
          //   kalau name == null atau !mounted → return
          //   ChatService.createRoom(name);   (tanpa await)
          //   showToast(context, 'Room "$name" dibuat');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
