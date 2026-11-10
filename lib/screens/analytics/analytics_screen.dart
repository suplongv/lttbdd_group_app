import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/expense_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import '../../widgets/category_icon_badge.dart';
import '../../widgets/date_selector_bar.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  bool _isYearly = false; // Hàng Tháng / Hàng Năm
  bool _showIncomeTab = false; // Chi tiêu / Thu nhập
  DateTime _selectedDate = DateTime.now();

  void _openSearchSheet(BuildContext context, ExpenseProvider provider) {
    String query = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.creamBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final results = query.isEmpty
              ? provider.transactions
              : provider.transactions
                  .where((t) =>
                      t.categoryName.toLowerCase().contains(query.toLowerCase()) ||
                      t.note.toLowerCase().contains(query.toLowerCase()))
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
                    onChanged: (v) => setModalState(() => query = v.trim()),
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

  static const List<Color> _chartPalette = [
    Color(0xFFEC407A),
    Color(0xFF5C6BC0),
    Color(0xFF26A69A),
    Color(0xFFFFA726),
    Color(0xFF8D6E63),
    Color(0xFFAB47BC),
    Color(0xFF42A5F5),
    Color(0xFF66BB6A),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final periodTx = _isYearly
        ? provider.transactionsForYear(_selectedDate.year)
        : provider.transactionsForMonth(_selectedDate);

    final totalExpense = periodTx
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (s, t) => s + t.amount);
    final totalIncome = periodTx
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (s, t) => s + t.amount);
    final netTotal = totalIncome - totalExpense;

    final targetType = _showIncomeTab ? TransactionType.income : TransactionType.expense;
    final targetSum = _showIncomeTab ? totalIncome : totalExpense;

    final Map<String, double> byCategory = {};
    for (final tx in periodTx) {
      if (tx.type == targetType) {
        byCategory[tx.categoryId] = (byCategory[tx.categoryId] ?? 0) + tx.amount;
      }
    }

    final sorted = byCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final List<_DonutSlice> slices = List.generate(sorted.length, (i) {
      final entry = sorted[i];
      final cat = provider.findCategory(entry.key, fallbackType: targetType);
      final pct = targetSum > 0 ? (entry.value / targetSum * 100) : 0.0;
      return _DonutSlice(
        label: cat.name,
        amount: entry.value,
        percentage: pct,
        color: _chartPalette[i % _chartPalette.length],
      );
    });

    return Scaffold(
      backgroundColor: AppColors.creamBg,
      body: Column(
        children: [
          // Header xanh lá pastel (#92C58E) với nút chuyển Hàng Tháng / Hàng Năm
          Container(
            color: AppColors.headerGreen,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              bottom: 14,
              left: 18,
              right: 18,
            ),
            child: Row(
              children: [
                const SizedBox(width: 38),
                Expanded(
                  child: Center(
                    child: Container(
                      height: 36,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB5C7B1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _HeaderModeTab(
                            label: 'Hàng Tháng',
                            isActive: !_isYearly,
                            onTap: () => setState(() => _isYearly = false),
                          ),
                          _HeaderModeTab(
                            label: 'Hàng Năm',
                            isActive: _isYearly,
                            onTap: () => setState(() => _isYearly = true),
                          ),
                        ],
                      ),
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
              child: Column(
                children: [
                  // Phần nền trắng phía trên (chọn ngày, 3 ô thống kê, biểu đồ Donut)
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
                    child: Column(
                      children: [
                        DateSelectorBar(
                          selectedDate: _selectedDate,
                          customLabel: _isYearly ? 'Năm ${_selectedDate.year}' : null,
                          onPrevious: () => setState(() {
                            _selectedDate = _isYearly
                                ? DateTime(_selectedDate.year - 1, _selectedDate.month, _selectedDate.day)
                                : DateTime(_selectedDate.year, _selectedDate.month - 1, _selectedDate.day);
                          }),
                          onNext: () => setState(() {
                            _selectedDate = _isYearly
                                ? DateTime(_selectedDate.year + 1, _selectedDate.month, _selectedDate.day)
                                : DateTime(_selectedDate.year, _selectedDate.month + 1, _selectedDate.day);
                          }),
                        ),

                        const SizedBox(height: 14),

                        // 2 ô Chi tiêu & Thu nhập
                        Row(
                          children: [
                            Expanded(
                              child: _BorderedStatBox(
                                label: 'Chi tiêu',
                                value: '-${formatVND(totalExpense, withSpace: false, symbol: '₫')}',
                                valueColor: AppColors.expenseRed,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: _BorderedStatBox(
                                label: 'Thu nhập',
                                value: '+${formatVND(totalIncome, withSpace: false, symbol: '₫')}',
                                valueColor: AppColors.incomeBlue,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        // Ô Thu chi toàn chiều rộng
                        _BorderedStatBox(
                          label: 'Thu chi',
                          value:
                              '${netTotal >= 0 ? '+' : ''}${formatVND(netTotal, withSpace: false, symbol: '₫')}',
                          valueColor: AppColors.textPrimary,
                        ),

                        const SizedBox(height: 14),

                        // Tab Chi tiêu / Thu nhập
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _showIncomeTab = false),
                                child: Container(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: !_showIncomeTab
                                            ? const Color(0xFF707870)
                                            : const Color(0xFFD5DAD4),
                                        width: !_showIncomeTab ? 2.2 : 1,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Chi tiêu',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: !_showIncomeTab
                                          ? FontWeight.w800
                                          : FontWeight.w500,
                                      color: !_showIncomeTab
                                          ? AppColors.textPrimary
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _showIncomeTab = true),
                                child: Container(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: _showIncomeTab
                                            ? const Color(0xFF707870)
                                            : const Color(0xFFD5DAD4),
                                        width: _showIncomeTab ? 2.2 : 1,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Thu nhập',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: _showIncomeTab
                                          ? FontWeight.w800
                                          : FontWeight.w500,
                                      color: _showIncomeTab
                                          ? AppColors.textPrimary
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 22),

                        // Biểu đồ tròn Donut hoặc thông báo trống
                        if (slices.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 44),
                            child: Text(
                              'Chưa có dữ liệu trong khoảng thời gian này',
                              style: TextStyle(fontSize: 13.5, color: AppColors.textMuted),
                            ),
                          )
                        else ...[
                          SizedBox(
                            width: 210,
                            height: 210,
                            child: CustomPaint(
                              painter: _DonutChartPainter(slices: slices),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Chú thích từng danh mục dạng pill viền mảnh
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: slices.map((s) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 6),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: const Color(0xFFA0A79F)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 9,
                                      height: 9,
                                      decoration: BoxDecoration(
                                        color: s.color,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${s.label} (${formatVND(s.amount, withSpace: false, symbol: '₫')})',
                                      style: const TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderModeTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _HeaderModeTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFDCE3D6) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
            color: AppColors.headerTitleGreen,
          ),
        ),
      ),
    );
  }
}

class _BorderedStatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _BorderedStatBox({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFA0A79F), width: 1),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
          ),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DonutSlice {
  final String label;
  final double amount;
  final double percentage;
  final Color color;

  _DonutSlice({
    required this.label,
    required this.amount,
    required this.percentage,
    required this.color,
  });
}

class _DonutChartPainter extends CustomPainter {
  final List<_DonutSlice> slices;

  _DonutChartPainter({required this.slices});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = math.min(size.width, size.height) / 2;
    final innerRadius = outerRadius * 0.48;
    final strokeWidth = outerRadius - innerRadius;
    final ringRadius = innerRadius + strokeWidth / 2;

    double startAngle = -math.pi / 2;
    final totalPct = slices.fold(0.0, (s, item) => s + item.percentage);
    if (totalPct <= 0) return;

    for (final slice in slices) {
      final sweepAngle = (slice.percentage / totalPct) * 2 * math.pi;

      final paint = Paint()
        ..color = slice.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: ringRadius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      // Đường phân cách màu trắng giữa các phần
      if (slices.length > 1) {
        final dividerPaint = Paint()
          ..color = Colors.white
          ..strokeWidth = 2.5;
        final dx = math.cos(startAngle) * outerRadius;
        final dy = math.sin(startAngle) * outerRadius;
        canvas.drawLine(center, center + Offset(dx, dy), dividerPaint);
      }

      // Nhãn phần trăm nằm giữa lát biểu đồ
      if (slice.percentage >= 6) {
        final midAngle = startAngle + sweepAngle / 2;
        final labelPos = Offset(
          center.dx + math.cos(midAngle) * ringRadius,
          center.dy + math.sin(midAngle) * ringRadius,
        );

        final textPainter = TextPainter(
          text: TextSpan(
            text: '${slice.percentage.round()}%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        textPainter.paint(
          canvas,
          labelPos - Offset(textPainter.width / 2, textPainter.height / 2),
        );
      }

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) => true;
}

