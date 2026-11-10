import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/expense_provider.dart';
import '../../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showEditNameDialog(BuildContext context, AuthProvider authProvider) {
    final nameCtrl = TextEditingController(
      text: authProvider.user?.displayName ?? 'Nguyễn Văn A',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.creamBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Chỉnh sửa tên hiển thị',
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.w800,
            color: AppColors.darkGreen,
          ),
        ),
        content: TextField(
          controller: nameCtrl,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Nhập họ và tên mới',
            filled: true,
            fillColor: AppColors.inputSage,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = nameCtrl.text.trim();
              if (newName.isNotEmpty) {
                await authProvider.updateDisplayName(newName);
              }
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _showHelpSheet(BuildContext context, ExpenseProvider expenseProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.creamBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
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
            const SizedBox(height: 16),
            const Text(
              'Trợ giúp & Cài đặt nhanh',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.darkGreen,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '• Bấm nút Mic hoặc "Nhập thủ công" ở Trang chủ để ghi thu/chi.\n'
              '• Chọn tab Ngân sách để đặt hạn mức chi tiêu cho từng danh mục.\n'
              '• Vuốt sang trái trên giao dịch ở Trang chủ để xóa nhanh.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  expenseProvider.resetToCleanDefault();
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã đặt lại dữ liệu về mặc định')),
                  );
                },
                icon: const Icon(Icons.refresh_rounded, color: AppColors.expenseRed),
                label: const Text(
                  'Đặt lại dữ liệu mẫu về 0',
                  style: TextStyle(color: AppColors.expenseRed, fontWeight: FontWeight.w700),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.expenseRed),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.creamBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Đăng xuất tài khoản?',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.darkGreen,
          ),
        ),
        content: const Text(
          'Bạn có chắc chắn muốn đăng xuất khỏi Save For You?',
          style: TextStyle(fontSize: 13.5, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.expenseRed),
            onPressed: () {
              Navigator.pop(ctx);
              authProvider.logout();
            },
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final expenseProvider = context.watch<ExpenseProvider>();
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: AppColors.creamBg,
      body: Column(
        children: [
          // Header xanh lá pastel (#92C58E) với tiêu đề "Cá nhân" & nút "Trợ giúp"
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
                const SizedBox(width: 72),
                const Expanded(
                  child: Text(
                    'Cá nhân',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: AppColors.headerTitleGreen,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _showHelpSheet(context, expenseProvider),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.headerCircleBtn,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Trợ giúp',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.headerTitleGreen,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 28),
              child: Column(
                children: [
                  // Biểu tượng Avatar tròn nét mảnh lớn ở giữa
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.darkGreen, width: 3.2),
                    ),
                    child: const Icon(
                      Icons.person_outline_rounded,
                      size: 56,
                      color: AppColors.darkGreen,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Thẻ thông tin người dùng (#DFE5DE)
                  InkWell(
                    onTap: () => _showEditNameDialog(context, authProvider),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
                      decoration: BoxDecoration(
                        color: AppColors.cardSage,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.displayName ?? 'Nguyễn Văn A',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.darkGreen,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  user?.email ?? 'nguyenvana111111@gmail.com',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.textSecondary,
                                      width: 0.9,
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.edit_outlined,
                                        size: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Chỉnh sửa',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.textPrimary,
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Nút Đăng xuất pill màu xám xanh nhạt với chữ đỏ đậm
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => _confirmLogout(context, authProvider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.cardSage,
                        foregroundColor: AppColors.expenseRed,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Đăng xuất',
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.expenseRed,
                        ),
                      ),
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

