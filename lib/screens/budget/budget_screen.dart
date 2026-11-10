import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/expense_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import '../../widgets/category_icon_badge.dart';
import '../../widgets/date_selector_bar.dart';
import 'category_detail_screen.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  DateTime _selectedDate = DateTime.now();
  bool _onlyConfigured = false;

  void _showSetBudgetDialog({
    required BuildContext context,
    required ExpenseProvider provider,
    required String title,
    required double? currentBudget,
    required ValueChanged<double?> onSave,
    VoidCallback? onViewDetail,
  }) {
    final ctrl = TextEditingController(
      text: currentBudget != null && currentBudget > 0
          ? currentBudget.round().toString()
          : '',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.creamBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Đặt ngân sách: $title',
          style: const TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.w800,
            color: AppColors.darkGreen,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Nhập hạn mức chi tiêu (VD: 2000000)',
                suffixText: 'đ',
                filled: true,
                fillColor: AppColors.inputSage,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            if (onViewDetail != null) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    onViewDetail();
                  },
                  icon: const Icon(Icons.bar_chart_rounded, size: 17, color: AppColors.darkGreen),
                  label: const Text(
                    'Xem biểu đồ chi tiêu danh mục',
                    style: TextStyle(fontSize: 12.5, color: AppColors.darkGreen, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (currentBudget != null && currentBudget > 0)
            TextButton(
              onPressed: () {
                onSave(null);
                Navigator.pop(ctx);
              },
              child: const Text('Xóa hạn mức', style: TextStyle(color: AppColors.expenseRed)),
            ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              final cleaned = ctrl.text.trim().replaceAll(',', '').replaceAll('.', '');
              final val = double.tryParse(cleaned);
              onSave(val != null && val > 0 ? val : null);
              Navigator.pop(ctx);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final totalBudget = provider.getTotalBudget(_selectedDate);
    final totalSpent = provider.totalExpenseInMonth(_selectedDate);

    final categories = _onlyConfigured
        ? provider.expenseCategories
            .where((c) => provider.getCategoryBudget(_selectedDate, c.id) != null)
            .toList()
        : provider.expenseCategories;

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
              left: 20,
              right: 20,
            ),
            child: Row(
              children: [
                const SizedBox(width: 38),
                const Expanded(
                  child: Text(
                    'Ngân sách',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: AppColors.headerTitleGreen,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _onlyConfigured = !_onlyConfigured),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: _onlyConfigured
                          ? AppColors.darkGreen
                          : AppColors.headerCircleBtn,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.tune_rounded,
                      color: _onlyConfigured
                          ? Colors.white
                          : AppColors.headerTitleGreen,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 32),
              child: Column(
                children: [
                  // Thanh chọn ngày/tháng
                  DateSelectorBar(
                    selectedDate: _selectedDate,
                    onPrevious: () => setState(() {
                      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, _selectedDate.day);
                    }),
                    onNext: () => setState(() {
                      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, _selectedDate.day);
                    }),
                  ),

                  const SizedBox(height: 14),

                  // Hàng Tổng ngân sách
                  _BudgetRowTile(
                    title: 'Tổng ngân sách',
                    budget: totalBudget,
                    spent: totalSpent,
                    progressColor: AppColors.expenseRed,
                    leading: null,
                    onTap: () => _showSetBudgetDialog(
                      context: context,
                      provider: provider,
                      title: 'Tổng ngân sách',
                      currentBudget: totalBudget,
                      onSave: (val) => provider.setTotalBudget(_selectedDate, val),
                    ),
                    onLongPress: () => _showSetBudgetDialog(
                      context: context,
                      provider: provider,
                      title: 'Tổng ngân sách',
                      currentBudget: totalBudget,
                      onSave: (val) => provider.setTotalBudget(_selectedDate, val),
                    ),
                  ),

                  const Divider(height: 1, color: AppColors.dividerColor),

                  // Danh sách từng danh mục chi tiêu
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: categories.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: AppColors.dividerColor),
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      final budget = provider.getCategoryBudget(_selectedDate, cat.id);
                      final spent = provider.expenseForCategoryInMonth(cat.id, _selectedDate);

                      return _BudgetRowTile(
                        title: cat.name,
                        budget: budget,
                        spent: spent,
                        progressColor: cat.color,
                        leading: CategoryIconBadge(category: cat, size: 38),
                        onTap: () {
                          if (budget == null) {
                            _showSetBudgetDialog(
                              context: context,
                              provider: provider,
                              title: cat.name,
                              currentBudget: null,
                              onSave: (val) => provider.setCategoryBudget(_selectedDate, cat.id, val),
                              onViewDetail: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CategoryDetailScreen(
                                      category: cat,
                                      initialMonth: _selectedDate,
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CategoryDetailScreen(
                                  category: cat,
                                  initialMonth: _selectedDate,
                                ),
                              ),
                            );
                          }
                        },
                        onLongPress: () => _showSetBudgetDialog(
                          context: context,
                          provider: provider,
                          title: cat.name,
                          currentBudget: budget,
                          onSave: (val) => provider.setCategoryBudget(_selectedDate, cat.id, val),
                        ),
                      );
                    },
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

class _BudgetRowTile extends StatelessWidget {
  final String title;
  final double? budget;
  final double spent;
  final Color progressColor;
  final Widget? leading;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _BudgetRowTile({
    required this.title,
    required this.budget,
    required this.spent,
    required this.progressColor,
    required this.leading,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final hasBudget = budget != null && budget! > 0;
    final remaining = hasBudget ? (budget! - spent) : 0.0;
    final ratio = hasBudget ? (spent / budget!).clamp(0.0, 1.0) : 0.0;
    final pct = hasBudget ? ((spent / budget!) * 100).round() : 0;

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.budgetGoldText,
                    ),
                  ),
                ),
                if (!hasBudget)
                  const Text(
                    'Chưa đặt',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textMuted,
                    ),
                  )
                else
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                      children: [
                        const TextSpan(text: 'Còn lại: '),
                        TextSpan(
                          text: formatVND(remaining, withSpace: false, symbol: '₫'),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: remaining < 0
                                ? AppColors.expenseRed
                                : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: hasBudget ? ratio : 0,
                      minHeight: 7,
                      backgroundColor: const Color(0xFFD6DBD4),
                      valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  hasBudget ? '$pct %' : '-',
                  style: const TextStyle(
                    fontSize: 12,
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
            if (hasBudget) ...[
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ngân sách: ${formatVND(budget!, withSpace: false, symbol: '₫')}',
                    style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 18),
                    child: Text(
                      'Chi tiêu ${formatVND(spent, withSpace: false, symbol: '₫')}',
                      style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

