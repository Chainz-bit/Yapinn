import 'package:flutter/material.dart';

import '../theme.dart';

/// Dialog nama room baru. Return nama (sudah di-trim) atau null kalau batal/kosong.
Future<String?> showCreateRoomDialog(BuildContext context) {
  final controller = TextEditingController();

  void submit(BuildContext dialogContext) {
    final name = controller.text.trim();
    Navigator.pop(dialogContext, name.isEmpty ? null : name);
  }

  return showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Room baru'),
      content: TextField(
        controller: controller,
        autofocus: true,
        maxLength: 30,
        decoration: const InputDecoration(hintText: 'Nama room'),
        onSubmitted: (_) => submit(dialogContext),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          style: TextButton.styleFrom(foregroundColor: kSubtle),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () => submit(dialogContext),
          style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
          child: const Text('Buat'),
        ),
      ],
    ),
  );
}

/// Dialog ganti nama room. Return nama baru atau null kalau batal/kosong.
Future<String?> showRenameRoomDialog(BuildContext context, String currentName) {
  final controller = TextEditingController(text: currentName);

  void submit(BuildContext dialogContext) {
    final name = controller.text.trim();
    Navigator.pop(dialogContext, name.isEmpty ? null : name);
  }

  return showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Ganti nama room'),
      content: TextField(
        controller: controller,
        autofocus: true,
        maxLength: 30,
        decoration: const InputDecoration(hintText: 'Nama room baru'),
        onSubmitted: (_) => submit(dialogContext),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          style: TextButton.styleFrom(foregroundColor: kSubtle),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () => submit(dialogContext),
          style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
          child: const Text('Simpan'),
        ),
      ],
    ),
  );
}

/// Bottom sheet konfirmasi hapus pesan. Return true kalau user memilih hapus.
Future<bool> showDeleteMessageSheet(BuildContext context) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: kSurface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: kLine,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Hapus pesan'),
            onTap: () => Navigator.pop(sheetContext, true),
          ),
          ListTile(
            leading: const Icon(Icons.close),
            title: const Text('Batal'),
            onTap: () => Navigator.pop(sheetContext, false),
          ),
        ],
      ),
    ),
  );
  return result ?? false;
}

/// Notifikasi singkat di bawah layar.
void showToast(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(text, style: const TextStyle(color: kOnInk)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: kInk,
        elevation: 0,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
}
