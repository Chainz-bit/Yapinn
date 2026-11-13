import 'package:flutter/material.dart';

import '../theme.dart';
import 'pulse.dart';

/// Kotak abu polos untuk skeleton.
Widget _bar(double width, double height, double radius) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: kField,
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}

/// Loading state daftar room.
class RoomListSkeleton extends StatelessWidget {
  const RoomListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Pulse(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        itemBuilder: (_, _) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(color: kField, shape: BoxShape.circle),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _bar(140, 12, 6),
                  const SizedBox(height: 8),
                  _bar(220, 10, 6),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Loading state halaman chat.
class ChatSkeleton extends StatelessWidget {
  const ChatSkeleton({super.key});

  static const _widths = [160.0, 220.0, 120.0, 200.0, 140.0, 180.0];

  @override
  Widget build(BuildContext context) {
    return Pulse(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            for (var i = 0; i < _widths.length; i++)
              Align(
                alignment: i.isEven ? Alignment.centerLeft : Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: _bar(_widths[i], 38, 20),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
