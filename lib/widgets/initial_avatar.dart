import 'package:flutter/material.dart';

import '../theme.dart';

/// Lingkaran gelap berisi huruf pertama nama.
class InitialAvatar extends StatelessWidget {
  final String name;
  final double radius;

  const InitialAvatar({super.key, required this.name, this.radius = 24});

  @override
  Widget build(BuildContext context) {
    final trimmed = name.trim();
    final initial = trimmed.isEmpty ? '?' : trimmed[0].toUpperCase();
    return CircleAvatar(
      radius: radius,
      backgroundColor: kInk,
      child: Text(
        initial,
        style: TextStyle(
          color: kOnInk,
          fontWeight: FontWeight.w600,
          fontSize: radius * 0.8,
        ),
      ),
    );
  }
}
