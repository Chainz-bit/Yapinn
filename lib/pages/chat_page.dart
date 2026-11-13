import 'package:flutter/material.dart';

import '../models/message.dart';
import '../models/room.dart';
import '../services/chat_service.dart';
import '../theme.dart';
import '../widgets/widgets.dart';

/// Halaman chat satu room.
class ChatPage extends StatefulWidget {
  final Room room;

  const ChatPage({super.key, required this.room});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Future<void> _confirmDelete(Message m) async {
    // TODO(6b): Konfirmasi lalu hapus pesan.
    // Petunjuk:
    //   final ok = await showDeleteMessageSheet(context);
    //   kalau !ok atau !mounted → return
    //   ChatService.deleteMessage(widget.room.id, m.id);   (tanpa await)
    //   showToast(context, 'Pesan dihapus');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            InitialAvatar(name: widget.room.name, radius: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.room.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ColoredBox(
              color: kChatBg,
              // TODO(4b): Ganti dengan StreamBuilder<List<Message>> dari ChatService.watchMessages(widget.room.id).
              //   Simpan stream-nya sekali sebagai field (late final), jangan dibuat ulang tiap build.
              //   error → EmptyState(icon: Icons.error_outline, text: 'Gagal memuat pesan')
              //   loading → ChatSkeleton()
              //   kosong → EmptyState(icon: Icons.waving_hand_outlined, text: 'Belum ada pesan.\nSapa duluan!')
              //   ada data → ListView.builder(reverse: true, padding: EdgeInsets.all(12), ...)
              //              tiap item: MessageBubble(key: ValueKey(m.id), message: m,
              //                         onLongPress: m.isMine ? () => _confirmDelete(m) : null)
              child: const EmptyState(
                icon: Icons.construction_outlined,
                text: 'TODO 4b\nTampilkan pesan di sini',
              ),
            ),
          ),
          MessageInput(
            onSend: (text) {
              // TODO(5b): Kirim pesan pakai ChatService.sendMessage(widget.room.id, text). Tanpa await.
            },
          ),
        ],
      ),
    );
  }
}
