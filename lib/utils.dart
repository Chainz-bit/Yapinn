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
