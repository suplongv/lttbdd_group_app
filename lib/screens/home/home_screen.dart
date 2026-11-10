import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/expense_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import '../../widgets/category_icon_badge.dart';
import '../../widgets/save_for_you_logo.dart';
import '../entry/select_category_screen.dart';
import '../entry/voice_entry_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onSeeAllTransactions;

  const HomeScreen({super.key, this.onSeeAllTransactions});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hideBalance = false;
  bool _showAllRecent = false;

  void _showNotificationsSheet(BuildContext context, ExpenseProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.creamBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Thông báo & Nhắc nhở',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.darkGreen,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cardSage,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.tips_and_updates_outlined, color: AppColors.darkGreen),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Bạn đã ghi nhận ${provider.transactions.length} giao dịch. Hãy duy trì thói quen ghi chép mỗi ngày nhé!',
                      style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final allTx = provider.transactions;
    final visibleTx = _showAllRecent ? allTx : allTx.take(5).toList();

    return Scaffold(
      backgroundColor: AppColors.creamBg,
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              color: AppColors.darkGreen,
              onRefresh: () async {},
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Header: Logo bên trái & Chuông thông báo bên phải
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SaveForYouLogo(
                          size: 34,
                          showDarkBox: false,
                          showText: false,
                        ),
                        IconButton(
                          onPressed: () => _showNotificationsSheet(context, provider),
                          icon: const Icon(
                            Icons.notifications_none_rounded,
                            color: AppColors.darkGreen,
                            size: 26,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // 2. Lời chào
                    const Text(
                      'Xin chào,',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkGreen,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Hôm nay bạn thế nào?',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.greetingGreen,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 3. Thẻ Tổng số dư màu xanh đậm (#293B2F)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                      decoration: BoxDecoration(
                        color: AppColors.darkGreen,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.darkGreen.withValues(alpha: 0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tổng số dư',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => setState(() => _hideBalance = !_hideBalance),
                                child: Icon(
                                  _hideBalance
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.white.withValues(alpha: 0.85),
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _hideBalance ? '•••••••• đ' : formatVND(provider.balance),
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 16),
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Thu nhập',
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          color: Colors.white.withValues(alpha: 0.72),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _hideBalance
                                            ? '+ •••••• đ'
                                            : '+ ${formatVND(provider.totalIncome)}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  margin: const EdgeInsets.symmetric(horizontal: 14),
                                  color: Colors.white.withValues(alpha: 0.25),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Chi tiêu',
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          color: Colors.white.withValues(alpha: 0.72),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _hideBalance
                                            ? '- •••••• đ'
                                            : '- ${formatVND(provider.totalExpense)}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    // 4. Tiêu đề "Gần đây" & "Xem tất cả >"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Gần đây',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.darkGreen,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (allTx.length > 5) {
                              setState(() => _showAllRecent = !_showAllRecent);
                            } else if (widget.onSeeAllTransactions != null) {
                              widget.onSeeAllTransactions!();
                            }
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _showAllRecent ? 'Thu gọn' : 'Xem tất cả',
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Icon(
                                Icons.chevron_right_rounded,
                                size: 17,
                                color: AppColors.textPrimary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // 5. Danh sách giao dịch gần đây
                    if (visibleTx.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 20),
                        decoration: BoxDecoration(
                          color: AppColors.cardSage,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Column(
                          children: [
                            Icon(Icons.receipt_long_outlined, size: 42, color: AppColors.textSecondary),
                            SizedBox(height: 8),
                            Text(
                              'Chưa có giao dịch nào',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Chọn Mic hoặc "Nhập thủ công" bên dưới để thêm giao dịch',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: visibleTx.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final tx = visibleTx[index];
                          final isIncome = tx.type == TransactionType.income;
                          final cat = provider.findCategory(
                            tx.categoryId,
                            fallbackType: tx.type,
                          );

                          return Dismissible(
                            key: Key(tx.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 18),
                              decoration: BoxDecoration(
                                color: AppColors.expenseRed,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
                            ),
                            onDismissed: (_) {
                              provider.deleteTransaction(tx.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Đã xóa giao dịch ${tx.categoryName}')),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                              decoration: BoxDecoration(
                                color: AppColors.cardSage,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  CategoryIconBadge(category: cat, size: 42),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tx.categoryName,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          formatRecentTime(tx.date),
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
                                          ? AppColors.incomeGreen
                                          : AppColors.expenseRed,
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
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),

            // 6. Hai nút nổi phía dưới: Mic (trái) & Nhập thủ công (phải)
            Positioned(
              left: 22,
              right: 22,
              bottom: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const VoiceEntryScreen()),
                      );
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.darkGreen,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.darkGreen.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.mic_none_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SelectCategoryScreen()),
                      );
                    },
                    child: Container(
                      height: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF9BA89E),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit_outlined, size: 15, color: Colors.white),
                          SizedBox(width: 6),
                          Text(
                            'Nhập thủ công',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

