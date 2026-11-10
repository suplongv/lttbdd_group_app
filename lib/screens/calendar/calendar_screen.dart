import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/expense_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import '../../widgets/category_icon_badge.dart';
import '../../widgets/date_selector_bar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();

  void _openSearchSheet(BuildContext context, ExpenseProvider provider) {
    String searchQuery = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.creamBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final results = searchQuery.isEmpty
              ? provider.transactions
              : provider.transactions
                  .where((t) =>
                      t.categoryName.toLowerCase().contains(searchQuery.toLowerCase()) ||
                      t.note.toLowerCase().contains(searchQuery.toLowerCase()))
                  .toList();

          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: SizedBox(
              height: MediaQuery.of(ctx).size.height * 0.65,
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    autofocus: true,
                    onChanged: (v) => setModalState(() => searchQuery = v.trim()),
                    decoration: InputDecoration(
                      hintText: 'Tìm giao dịch theo danh mục hoặc ghi chú...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: results.isEmpty
                        ? const Center(child: Text('Không tìm thấy giao dịch phù hợp'))
                        : ListView.separated(
                            itemCount: results.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (_, i) {
                              final tx = results[i];
                              final isIncome = tx.type == TransactionType.income;
                              final cat = provider.findCategory(tx.categoryId, fallbackType: tx.type);
                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.cardSage,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    CategoryIconBadge(category: cat, size: 36),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            tx.categoryName,
                                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                                          ),
                                          Text(
                                            tx.note.isNotEmpty ? tx.note : formatDayMonth(tx.date),
                                            style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${isIncome ? '+' : '-'}${formatVND(tx.amount)}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: isIncome ? AppColors.incomeBlue : AppColors.expenseRed,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final dayTransactions = provider.transactionsForDate(_selectedDate);

    final dayIncome = dayTransactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (s, t) => s + t.amount);
    final dayExpense = dayTransactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (s, t) => s + t.amount);
    final dayNet = dayIncome - dayExpense;

    final firstDay = DateTime(_selectedDate.year, _selectedDate.month, 1);
    final daysInMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 0).day;
    final leadingBlanks = firstDay.weekday - 1;
    final totalCells = leadingBlanks + daysInMonth;
    final rowCount = (totalCells / 7).ceil();

    const weekdays = ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'CN'];

    return Scaffold(
      backgroundColor: AppColors.creamBg,
      body: Column(
        children: [
          // Header xanh lá pastel (#92C58E) với tiêu đề "Lịch" & nút tìm kiếm tròn
          Container(
            color: AppColors.headerGreen,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              bottom: 14,
              left: 20,
              right: 20,
            ),
            child: Row(
              children: [
                const SizedBox(width: 38),
                const Expanded(
                  child: Text(
                    'Lịch',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: AppColors.headerTitleGreen,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _openSearchSheet(context, provider),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: AppColors.headerCircleBtn,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.search_rounded,
                      color: AppColors.headerTitleGreen,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
              child: Column(
                children: [
                  // Thanh chọn ngày vàng nhạt
                  DateSelectorBar(
                    selectedDate: _selectedDate,
                    onPrevious: () => setState(() {
                      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
                    }),
                    onNext: () => setState(() {
                      _selectedDate = _selectedDate.add(const Duration(days: 1));
                    }),
                    onTapDate: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                  ),

                  const SizedBox(height: 14),

                  // Khung lịch tháng (#E9EFD5)
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
                    decoration: BoxDecoration(
                      color: AppColors.calendarBg,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        // Dải tiêu đề thứ trong tuần
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                          decoration: BoxDecoration(
                            color: AppColors.calendarHeaderBg,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: List.generate(7, (idx) {
                              Color textColor = AppColors.textPrimary;
                              if (idx == 5) textColor = AppColors.incomeBlue;
                              if (idx == 6) textColor = AppColors.expenseRed;

                              return Expanded(
                                child: Center(
                                  child: Text(
                                    weekdays[idx],
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Lưới ngày trong tháng
                        ...List.generate(rowCount, (r) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: List.generate(7, (c) {
                                final cellIndex = r * 7 + c;
                                final dayNum = cellIndex - leadingBlanks + 1;
                                if (dayNum < 1 || dayNum > daysInMonth) {
                                  return const Expanded(child: SizedBox(height: 36));
                                }

                                final cellDate = DateTime(_selectedDate.year, _selectedDate.month, dayNum);
                                final isSelected = dayNum == _selectedDate.day;
                                final hasTx = provider.transactionsForDate(cellDate).isNotEmpty;

                                Color dayColor = AppColors.textPrimary;
                                if (c == 5) dayColor = AppColors.incomeBlue;
                                if (c == 6) dayColor = AppColors.expenseRed;

                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(() => _selectedDate = cellDate),
                                    child: Center(
                                      child: Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.calendarSelected
                                              : Colors.transparent,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '$dayNum',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: isSelected
                                                    ? FontWeight.w800
                                                    : FontWeight.w600,
                                                color: dayColor,
                                              ),
                                            ),
                                            if (hasTx)
                                              Container(
                                                width: 4,
                                                height: 4,
                                                margin: const EdgeInsets.only(top: 1),
                                                decoration: const BoxDecoration(
                                                  color: AppColors.darkGreen,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                          ],
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
                  ),

                  const SizedBox(height: 16),

                  // 3 thẻ tóm tắt Thu nhập / Chi tiêu / Tổng
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.calendarBg,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _SummaryMiniCard(
                            title: 'Thu nhập',
                            value: formatVND(dayIncome),
                            valueColor: AppColors.incomeBlue,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _SummaryMiniCard(
                            title: 'Chi tiêu',
                            value: formatVND(dayExpense),
                            valueColor: AppColors.expenseRed,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _SummaryMiniCard(
                            title: 'Tổng',
                            value: '${dayNet >= 0 ? '+ ' : ''}${formatVND(dayNet)}',
                            valueColor: dayNet >= 0
                                ? AppColors.incomeBlue
                                : AppColors.expenseRed,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Danh sách giao dịch của ngày đang chọn (nếu có)
                  if (dayTransactions.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: dayTransactions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final tx = dayTransactions[index];
                        final isIncome = tx.type == TransactionType.income;
                        final cat = provider.findCategory(tx.categoryId, fallbackType: tx.type);

                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.cardSage,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              CategoryIconBadge(category: cat, size: 36),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tx.categoryName,
                                      style: const TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    if (tx.note.isNotEmpty)
                                      Text(
                                        tx.note,
                                        style: const TextStyle(
                                          fontSize: 11.5,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Text(
                                '${isIncome ? '+ ' : '- '}${formatVND(tx.amount)}',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: isIncome
                                      ? AppColors.incomeBlue
                                      : AppColors.expenseRed,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryMiniCard extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;

  const _SummaryMiniCard({
    required this.title,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.summaryBoxBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: valueColor,
                decoration: TextDecoration.underline,
                decorationColor: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

