import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/message.dart';
import '../theme.dart';
import '../utils.dart';

/// Bubble pesan. Kanan = pesan sendiri, kiri = orang lain.
class MessageBubble extends StatelessWidget {
  final Message message;
  final VoidCallback? onLongPress;

  const MessageBubble({super.key, required this.message, this.onLongPress});

  /// Pesan dianggap "segar" kalau belum punya waktu server atau umurnya < 5 detik.
  bool get _isFresh {
    final t = message.createdAt;
    return t == null || DateTime.now().difference(t).inSeconds < 5;
  }

  @override
  Widget build(BuildContext context) {
    final mine = message.isMine;
    final footerColor = mine ? kOnInk.withValues(alpha: 0.6) : kSubtle;

    Widget bubble = Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.75),
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
      decoration: BoxDecoration(
        color: mine ? kInk : kSurface,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(mine ? 20 : 6),
          bottomRight: Radius.circular(mine ? 6 : 20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!mine)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                message.senderName,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kSubtle),
              ),
            ),
          Text(
            message.text,
            style: TextStyle(fontSize: 15, height: 1.3, color: mine ? kOnInk : kText),
          ),
          const SizedBox(height: 2),
          Align(
            alignment: Alignment.centerRight,
            widthFactor: 1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formatTime(message.createdAt ?? DateTime.now()),
                  style: TextStyle(fontSize: 10, color: footerColor),
                ),
                if (mine) ...[
                  const SizedBox(width: 4),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) => ScaleTransition(
                      scale: animation,
                      child: FadeTransition(opacity: animation, child: child),
                    ),
                    child: Icon(
                      message.isPending ? Icons.schedule : Icons.check,
                      key: ValueKey(message.isPending),
                      size: 12,
                      color: footerColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    // Animasi "pop" hanya untuk pesan baru, bukan pesan lama.
    if (_isFresh) {
      bubble = TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutBack,
        builder: (context, v, child) => Transform.scale(
          scale: 0.85 + 0.15 * v,
          alignment: mine ? Alignment.bottomRight : Alignment.bottomLeft,
          child: Opacity(opacity: v.clamp(0.0, 1.0), child: child),
        ),
        child: bubble,
      );
    }

    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: onLongPress == null
            ? null
            : () {
                HapticFeedback.selectionClick();
                onLongPress!();
              },
        child: bubble,
      ),
    );
  }
}
