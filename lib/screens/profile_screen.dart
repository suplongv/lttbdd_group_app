import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/formatters.dart';
import '../providers/expense_provider.dart';
import '../providers/auth_provider.dart';
import '../models/models.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showDepositDialog(BuildContext context, ExpenseProvider provider, SavingsGoal goal) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Nạp tiền: ${goal.name}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Số tiền muốn nạp (₫)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF223B20),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final amt = double.tryParse(controller.text.trim().replaceAll(',', '').replaceAll('.', ''));
              if (amt != null && amt > 0) {
                provider.depositToSavings(goal.id, amt);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đã nạp ${formatVND(amt)} vào ${goal.name}'),
                    backgroundColor: const Color(0xFF223B20),
                  ),
                );
              }
            },
            child: const Text('Nạp tiền'),
          ),
        ],
      ),
    );
  }

  void _showWithdrawDialog(BuildContext context, ExpenseProvider provider, SavingsGoal goal) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Rút tiền: ${goal.name}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Số tiền muốn rút (₫)',
            helperText: 'Tối đa: ${formatVND(goal.currentAmount)}',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade800,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final amt = double.tryParse(controller.text.trim().replaceAll(',', '').replaceAll('.', ''));
              if (amt != null && amt > 0) {
                provider.withdrawFromSavings(goal.id, amt);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đã rút ${formatVND(amt)} từ ${goal.name}'),
                    backgroundColor: const Color(0xFF223B20),
                  ),
                );
              }
            },
            child: const Text('Rút tiền'),
          ),
        ],
      ),
    );
  }

  void _confirmResetData(BuildContext context, ExpenseProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận đặt lại dữ liệu?'),
        content: const Text(
          'Thao tác này sẽ xóa toàn bộ lịch sử giao dịch và đặt lại các quỹ tiết kiệm về 0.\nBạn có chắc chắn muốn thực hiện?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              provider.resetToCleanDefault();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã đặt lại dữ liệu về trạng thái ban đầu!'),
                  backgroundColor: Color(0xFF223B20),
                ),
              );
            },
            child: const Text('Đặt lại'),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Đăng xuất tài khoản?'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF223B20),
              foregroundColor: Colors.white,
            ),
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
    final provider = context.watch<ExpenseProvider>();
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final savingsGoals = provider.savingsGoals;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tài Khoản & Quỹ Tiết Kiệm',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF223B20)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. User Info Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Color(0xFF223B20),
                    child: Icon(Icons.person, color: Color(0xFFD6E6B8), size: 32),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.displayName ?? 'Quản Lý Tài Chính Cá Nhân',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF223B20)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.email ?? 'Sổ Chi Tiêu & Quỹ Dự Phòng Khẩn Cấp',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 2. Savings Goals List
            const Text(
              'Mục tiêu tiết kiệm & Quỹ dự phòng',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF223B20)),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: savingsGoals.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (ctx, i) {
                final goal = savingsGoals[i];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              goal.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          Text(
                            '${goal.progressPercentage.toStringAsFixed(1)}%',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF223B20)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: goal.progressPercentage / 100,
                          minHeight: 8,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF223B20)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Hiện có: ${formatVND(goal.currentAmount)}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF223B20)),
                          ),
                          Text(
                            'Mục tiêu: ${formatVND(goal.targetAmount)}',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => _showWithdrawDialog(context, provider, goal),
                            icon: const Icon(Icons.remove, size: 14),
                            label: const Text('Rút'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey.shade800,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () => _showDepositDialog(context, provider, goal),
                            icon: const Icon(Icons.add, size: 14),
                            label: const Text('Nạp tiền'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF223B20),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // 3. Settings & Data Actions
            const Text(
              'Cài đặt & Dữ liệu',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF223B20)),
            ),
            const SizedBox(height: 12),
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.refresh_rounded, color: Colors.redAccent),
                    title: const Text('Đặt lại dữ liệu ban đầu', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Xóa toàn bộ giao dịch và đưa các quỹ về 0'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _confirmResetData(context, provider),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    leading: Icon(Icons.info_outline_rounded, color: Color(0xFF223B20)),
                    title: Text('Phiên bản ứng dụng'),
                    subtitle: Text('v1.0.0 (Flutter Dart thuần túy)'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                    title: const Text('Đăng xuất tài khoản', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600)),
                    subtitle: Text('Đang đăng nhập: ${user?.email ?? ""}'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _confirmLogout(context, authProvider),
                  ),
                ],
              ),
            ),
          ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
