import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/expense_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/category_icon_badge.dart';
import 'transaction_detail_screen.dart';

class SelectCategoryScreen extends StatefulWidget {
  final bool initialIsIncome;

  const SelectCategoryScreen({super.key, this.initialIsIncome = false});

  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  late bool _isIncome;
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _isIncome = widget.initialIsIncome;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final sourceList = _isIncome ? provider.incomeCategories : provider.expenseCategories;
    final filtered = _query.isEmpty
        ? sourceList
        : sourceList
            .where((c) => c.name.toLowerCase().contains(_query.toLowerCase()))
            .toList();

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
          'Chọn danh mục',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.darkGreen,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            // Tab chuyển Chi tiêu / Thu nhập
            Row(
              children: [
                Expanded(
                  child: _SegmentPill(
                    label: 'Chi tiêu',
                    isActive: !_isIncome,
                    onTap: () => setState(() => _isIncome = false),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _SegmentPill(
                    label: 'Thu nhập',
                    isActive: _isIncome,
                    onTap: () => setState(() => _isIncome = true),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Thanh tìm kiếm danh mục
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFD5DCCD)),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _query = val.trim()),
                style: const TextStyle(fontSize: 13.5, color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Tìm kiếm danh mục...',
                  hintStyle: TextStyle(fontSize: 13, color: AppColors.textMuted),
                  prefixIcon: Icon(Icons.search_rounded, size: 20, color: AppColors.textMuted),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              _isIncome ? 'Danh mục thu nhập' : 'Danh mục chi tiêu',
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w800,
                color: AppColors.darkGreen,
              ),
            ),

            const SizedBox(height: 10),

            // Danh sách danh mục
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final cat = filtered[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TransactionDetailScreen(
                            category: cat,
                            isIncome: _isIncome,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.cardSage,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          CategoryIconBadge(category: cat, size: 36),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              cat.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            size: 20,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentPill extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SegmentPill({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 36,
        decoration: BoxDecoration(
          color: isActive ? AppColors.darkGreen : const Color(0xFFD5DDD0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: isActive ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

