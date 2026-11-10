import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/expense_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import '../../widgets/category_icon_badge.dart';

class CategoryDetailScreen extends StatelessWidget {
  final ExpenseCategory category;
  final DateTime initialMonth;

  const CategoryDetailScreen({
    super.key,
    required this.category,
    required this.initialMonth,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();

    // 5 tháng gần nhất kết thúc ở initialMonth (VD: T6, T7, T8, T9, T10)
    final List<DateTime> months = List.generate(5, (i) {
      return DateTime(initialMonth.year, initialMonth.month - (4 - i));
    });

    final List<double> monthlyTotals = months
        .map((m) => provider.expenseForCategoryInMonth(category.id, m))
        .toList();

    final currentMonthTotal = monthlyTotals.last;

    // Giao dịch của danh mục trong tháng đang xem
    final monthTx = provider
        .transactionsForMonth(initialMonth)
        .where((t) => t.categoryId == category.id && t.type == TransactionType.expense)
        .toList();

    // Nhóm giao dịch theo ngày
    final Map<String, List<TransactionItem>> grouped = {};
    for (final tx in monthTx) {
      final key = formatDayMonth(tx.date);
      grouped.putIfAbsent(key, () => []).add(tx);
    }

    return Scaffold(
      backgroundColor: AppColors.creamBg,
      body: Column(
        children: [
          // Header xanh lá pastel (#92C58E)
          Container(
            color: AppColors.headerGreen,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              bottom: 14,
              left: 16,
              right: 16,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: AppColors.headerCircleBtn,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chevron_left_rounded,
                      color: AppColors.headerTitleGreen,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${category.name} (T${initialMonth.month}) ${formatVND(currentMonthTotal, withSpace: false, symbol: '₫')}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.headerTitleGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Khu vực biểu đồ cột 5 tháng trên nền trắng
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
            child: _MonthlyBarChart(
              months: months,
              values: monthlyTotals,
              barColor: const Color(0xFFE66316),
            ),
          ),

          // Danh sách giao dịch nhóm theo ngày
          Expanded(
            child: grouped.isEmpty
                ? const Center(
                    child: Text(
                      'Chưa có giao dịch nào trong tháng này',
                      style: TextStyle(fontSize: 13.5, color: AppColors.textSecondary),
                    ),
                  )
                : ListView(
                    padding: EdgeInsets.zero,
                    children: grouped.entries.map((entry) {
                      final daySum = entry.value.fold(0.0, (s, t) => s + t.amount);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                            color: const Color(0xFFE1ECC8),
                            child: Text(
                              '${entry.key} (${formatVND(daySum, withSpace: false, symbol: '₫')})',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          ...entry.value.map((tx) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: const BoxDecoration(
                                color: AppColors.creamBg,
                                border: Border(
                                  bottom: BorderSide(color: Color(0xFFE4E9DC)),
                                ),
                              ),
                              child: Row(
                                children: [
                                  CategoryIconBadge(category: category, size: 36),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tx.note.isNotEmpty ? tx.note : category.name,
                                          style: const TextStyle(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.budgetGoldText,
                                          ),
                                        ),
                                        Text(
                                          formatDayMonth(tx.date),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '-${formatVND(tx.amount, withSpace: false, symbol: '₫')}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.chevron_right_rounded,
                                    size: 16,
                                    color: AppColors.textSecondary,
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class _MonthlyBarChart extends StatelessWidget {
  final List<DateTime> months;
  final List<double> values;
  final Color barColor;

  const _MonthlyBarChart({
    required this.months,
    required this.values,
    required this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    final maxVal = values.fold<double>(0, math.max);
    final ceiling = maxVal <= 0 ? 500.0 : (maxVal * 1.15).ceilToDouble();

    return SizedBox(
      height: 195,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // 5 đường kẻ ngang + nhãn trục Y
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (i) {
                    final tickVal = ceiling * (5 - i) / 5;
                    return Row(
                      children: [
                        SizedBox(
                          width: 44,
                          child: Text(
                            tickVal >= 1000000
                                ? '${(tickVal / 1000000).toStringAsFixed(1)}tr'
                                : tickVal >= 1000
                                    ? '${(tickVal / 1000).round()}k'
                                    : '${tickVal.round()}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: const Color(0xFFDADEDA),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                // Các cột dữ liệu
                Padding(
                  padding: const EdgeInsets.only(left: 44, bottom: 6, top: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(months.length, (i) {
                      final val = values[i];
                      final fraction = ceiling > 0 ? (val / ceiling).clamp(0.0, 1.0) : 0.0;
                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              formatVND(val, withSpace: false, symbol: '₫'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: barColor,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Flexible(
                              child: FractionallySizedBox(
                                heightFactor: fraction > 0 ? math.max(fraction, 0.04) : 0.015,
                                child: Container(
                                  width: 24,
                                  decoration: BoxDecoration(
                                    color: val > 0 ? barColor : Colors.transparent,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(3),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 44),
            child: Row(
              children: months
                  .map((m) => Expanded(
                        child: Center(
                          child: Text(
                            'T${m.month}',
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

