String formatVND(double amount) {
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
  return '${isNegative ? '-' : ''}${buffer.toString()} ₫';
}

String formatHeaderDate(DateTime date) {
  const weekdays = ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'Chủ nhật'];
  final weekday = weekdays[date.weekday - 1];
  final d = date.day.toString().padLeft(2, '0');
  final m = date.month.toString().padLeft(2, '0');
  return '$weekday, $d/$m/${date.year}';
}

String formatTransactionDate(DateTime date) {
  final d = date.day.toString().padLeft(2, '0');
  final m = date.month.toString().padLeft(2, '0');
  final h = date.hour.toString().padLeft(2, '0');
  final min = date.minute.toString().padLeft(2, '0');
  return '$d/$m $h:$min';
}
