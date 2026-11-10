import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/expense_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import '../../widgets/category_icon_badge.dart';

class TransactionDetailScreen extends StatefulWidget {
  final ExpenseCategory category;
  final bool isIncome;

  const TransactionDetailScreen({
    super.key,
    required this.category,
    required this.isIncome,
  });

  @override
  State<TransactionDetailScreen> createState() => _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  late ExpenseCategory _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  late DateTime _calendarMonth;
  bool _showInlineCalendar = false;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category;
    _calendarMonth = DateTime(_selectedDate.year, _selectedDate.month);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _saveTransaction() {
    final cleaned = _amountController.text.trim().replaceAll(',', '').replaceAll('.', '');
    final amount = double.tryParse(cleaned);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập số tiền hợp lệ lớn hơn 0'),
          backgroundColor: AppColors.expenseRed,
        ),
      );
      return;
    }

    final provider = context.read<ExpenseProvider>();
    final now = DateTime.now();
    final txDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      now.hour,
      now.minute,
    );

    if (widget.isIncome) {
      provider.addIncome(
        amount: amount,
        categoryId: _selectedCategory.id,
        categoryName: _selectedCategory.name,
        note: _noteController.text.trim(),
        date: txDate,
      );
    } else {
      provider.addExpense(
        categoryId: _selectedCategory.id,
        categoryName: _selectedCategory.name,
        amount: amount,
        note: _noteController.text.trim(),
        date: txDate,
      );
    }

    Navigator.of(context).popUntil((route) => route.isFirst);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.isIncome
              ? 'Đã thêm thu nhập ${_selectedCategory.name}'
              : 'Đã thêm chi tiêu ${_selectedCategory.name}',
        ),
        backgroundColor: AppColors.darkGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBg,
      appBar: AppBar(
        backgroundColor: AppColors.creamBg,
        foregroundColor: AppColors.darkGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Nhập chi tiết',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.darkGreen,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Thẻ danh mục đã chọn
            InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                decoration: BoxDecoration(
                  color: AppColors.cardSage,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    CategoryIconBadge(category: _selectedCategory, size: 36),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        _selectedCategory.name,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 20),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Ô Nhập số tiền
            Container(
              decoration: BoxDecoration(
                color: AppColors.inputSage,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                autofocus: true,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                decoration: const InputDecoration(
                  hintText: 'Nhập số tiền',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                  suffixText: 'đ',
                  suffixStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Ô Ghi chú
            Container(
              height: 108,
              decoration: BoxDecoration(
                color: AppColors.inputSage,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: _noteController,
                maxLines: 4,
                style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Ghi chú',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Thanh chọn ngày "< 16/10/2026 ( Thứ 6 ) >"
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: AppColors.cardSage,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded, size: 22),
                    color: AppColors.textPrimary,
                    onPressed: () {
                      setState(() {
                        _selectedDate = _selectedDate.subtract(const Duration(days: 1));
                        _calendarMonth = DateTime(_selectedDate.year, _selectedDate.month);
                      });
                    },
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _showInlineCalendar = !_showInlineCalendar),
                      child: Center(
                        child: Text(
                          formatPillDate(_selectedDate),
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded, size: 22),
                    color: AppColors.textPrimary,
                    onPressed: () {
                      setState(() {
                        _selectedDate = _selectedDate.add(const Duration(days: 1));
                        _calendarMonth = DateTime(_selectedDate.year, _selectedDate.month);
                      });
                    },
                  ),
                ],
              ),
            ),

            // Lịch inline mở rộng bên dưới khi bấm vào ngày
            if (_showInlineCalendar) ...[
              const SizedBox(height: 12),
              _InlineMonthCalendar(
                displayMonth: _calendarMonth,
                selectedDate: _selectedDate,
                onMonthChanged: (m) => setState(() => _calendarMonth = m),
                onDateSelected: (d) => setState(() => _selectedDate = d),
              ),
            ],

            const SizedBox(height: 28),

            // Nút Lưu giao dịch
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _saveTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: const Text(
                  'Lưu giao dịch',
                  style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InlineMonthCalendar extends StatelessWidget {
  final DateTime displayMonth;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<DateTime> onDateSelected;

  const _InlineMonthCalendar({
    required this.displayMonth,
    required this.selectedDate,
    required this.onMonthChanged,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(displayMonth.year, displayMonth.month, 1);
    final daysInMonth = DateTime(displayMonth.year, displayMonth.month + 1, 0).day;
    final leadingBlanks = firstDay.weekday - 1; // Monday = 0
    final totalCells = leadingBlanks + daysInMonth;
    final rows = (totalCells / 7).ceil();

    const headers = ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'CN'];

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: AppColors.inlineCalendarBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'tháng ${displayMonth.month} năm ${displayMonth.year} >',
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () => onMonthChanged(DateTime(displayMonth.year, displayMonth.month - 1)),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.chevron_left_rounded, size: 22, color: AppColors.textPrimary),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => onMonthChanged(DateTime(displayMonth.year, displayMonth.month + 1)),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.chevron_right_rounded, size: 22, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: headers
                .map((h) => Expanded(
                      child: Center(
                        child: Text(
                          h,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          ...List.generate(rows, (r) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: List.generate(7, (c) {
                  final idx = r * 7 + c;
                  final dayNum = idx - leadingBlanks + 1;
                  if (dayNum < 1 || dayNum > daysInMonth) {
                    return const Expanded(child: SizedBox(height: 30));
                  }
                  final cellDate = DateTime(displayMonth.year, displayMonth.month, dayNum);
                  final isSelected = cellDate.year == selectedDate.year &&
                      cellDate.month == selectedDate.month &&
                      cellDate.day == selectedDate.day;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onDateSelected(cellDate),
                      child: Center(
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.inlineCalendarSelected
                                : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '$dayNum',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ],
      ),
    );
  }
}

