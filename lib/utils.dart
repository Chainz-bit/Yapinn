/// Format waktu untuk daftar room & bubble.
/// Hari ini → "HH:mm", selain itu → "dd/MM", null → "".
String formatTime(DateTime? t) {
  if (t == null) return '';
  final now = DateTime.now();
  final isToday = t.year == now.year && t.month == now.month && t.day == now.day;
  String two(int n) => n.toString().padLeft(2, '0');
  if (isToday) return '${two(t.hour)}:${two(t.minute)}';
  return '${two(t.day)}/${two(t.month)}';
}

/// Format pemisah tanggal chat.
/// Hari ini → "Hari ini", Kemarin → "Kemarin", selain itu → "dd/MM/yyyy".
String formatDateSeparator(DateTime? t) {
  if (t == null) return '';
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final date = DateTime(t.year, t.month, t.day);
  final diff = today.difference(date).inDays;
  if (diff == 0) return 'Hari ini';
  if (diff == 1) return 'Kemarin';
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(t.day)}/${two(t.month)}/${t.year}';
}

/// Cek apakah dua waktu berada di hari kalender yang sama.
bool isSameDay(DateTime? a, DateTime? b) {
  if (a == null || b == null) return false;
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
