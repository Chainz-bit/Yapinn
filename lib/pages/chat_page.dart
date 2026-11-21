import 'package:flutter/material.dart';

import '../models/message.dart';
import '../models/room.dart';
import '../services/chat_service.dart';
import '../session.dart';
import '../theme.dart';
import '../utils.dart';
import '../widgets/widgets.dart';

/// Halaman chat satu room.
class ChatPage extends StatefulWidget {
  final Room room;

  const ChatPage({super.key, required this.room});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final _stream = ChatService.watchMessages(widget.room.id);

  @override
  void initState() {
    super.initState();
    Session.openRoomId = widget.room.id; // untuk popup pesan baru
  }

  @override
  void dispose() {
    if (Session.openRoomId == widget.room.id) Session.openRoomId = null;
    super.dispose();
  }

  Future<void> _confirmDelete(Message m) async {
    final ok = await showDeleteMessageSheet(context);
    if (!ok || !mounted) return;
    ChatService.deleteMessage(widget.room.id, m.id); // tanpa await
    showToast(context, 'Pesan dihapus');
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
              child: StreamBuilder<List<Message>>(
                stream: _stream,
                builder: (context, snap) {
                  if (snap.hasError) {
                    debugPrint('${snap.error}');
                    return const EmptyState(icon: Icons.error_outline, text: 'Gagal memuat pesan');
                  }
                  if (!snap.hasData) return const ChatSkeleton();
                  final messages = snap.data!;
                  if (messages.isEmpty) {
                    return const EmptyState(
                      icon: Icons.waving_hand_outlined,
                      text: 'Belum ada pesan.\nSapa duluan!',
                    );
                  }
                  return ListView.builder(
                    reverse: true, // + data descending = terbaru di bawah
                    padding: const EdgeInsets.all(12),
                    itemCount: messages.length,
                    itemBuilder: (_, i) {
                      final m = messages[i];
                      final isOldest = i == messages.length - 1;
                      final isDifferentDay = isOldest ||
                          !isSameDay(m.createdAt, messages[i + 1].createdAt);

                      final bubble = MessageBubble(
                        key: ValueKey(m.id),
                        message: m,
                        onLongPress: m.isMine ? () => _confirmDelete(m) : null,
                      );

                      if (!isDifferentDay || m.createdAt == null) {
                        return bubble;
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: kLine.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                formatDateSeparator(m.createdAt),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: kSubtle,
                                ),
                              ),
                            ),
                          ),
                          bubble,
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
          MessageInput(onSend: (text) => ChatService.sendMessage(widget.room.id, text)),
        ],
      ),
    );
  }
}
