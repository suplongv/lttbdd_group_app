String formatVND(double amount, {bool withSpace = true, String symbol = 'đ'}) {
  final isNegative = amount < 0;
  final absAmount = amount.abs().round();
  final str = absAmount.toString();
  final buffer = StringBuffer();
  for (int i = 0; i < str.length; i++) {
    if (i > 0 && (str.length - i) % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(str[i]);
  }
  final space = withSpace ? ' ' : '';
  return '${isNegative ? '-' : ''}${buffer.toString()}$space$symbol';
}

String getShortWeekday(DateTime date) {
  const weekdays = ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'CN'];
  return weekdays[date.weekday - 1];
}

/// Định dạng giống UI: "16/10/2026 ( Thứ 6 )"
String formatPillDate(DateTime date) {
  final d = date.day.toString().padLeft(2, '0');
  final m = date.month.toString().padLeft(2, '0');
  final weekday = getShortWeekday(date);
  return '$d/$m/${date.year} ( $weekday )';
}

/// Định dạng giống UI Home: "Hôm nay - 12:45" hoặc "16/10 - 12:45"
String formatRecentTime(DateTime date) {
  final now = DateTime.now();
  final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
  final yesterday = now.subtract(const Duration(days: 1));
  final isYesterday = date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day;

  final h = date.hour.toString().padLeft(2, '0');
  final min = date.minute.toString().padLeft(2, '0');

  if (isToday) {
    return 'Hôm nay - $h:$min';
  }
  if (isYesterday) {
    return 'Hôm qua - $h:$min';
  }
  final d = date.day.toString().padLeft(2, '0');
  final m = date.month.toString().padLeft(2, '0');
  return '$d/$m - $h:$min';
}

String formatDayMonth(DateTime date) {
  final d = date.day.toString().padLeft(2, '0');
  final m = date.month.toString().padLeft(2, '0');
  return '$d/$m';
}

String formatHeaderDate(DateTime date) {
  const weekdays = ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'Chủ nhật'];
  final weekday = weekdays[date.weekday - 1];
  final d = date.day.toString().padLeft(2, '0');
  final m = date.month.toString().padLeft(2, '0');
  return '$weekday, $d/$m/${date.year}';
}
