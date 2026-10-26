import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/formatters.dart';
import '../providers/expense_provider.dart';
import '../models/models.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final totalIncome = provider.totalIncome;
    final totalExpense = provider.totalExpense;
    final balance = provider.balance;

    final double savingsRate = totalIncome > 0
        ? ((totalIncome - totalExpense) / totalIncome * 100).clamp(0, 100)
        : 0;

    // Calculate expense by category
    final Map<String, double> categoryExpenses = {};
    for (final tx in provider.transactions) {
      if (tx.type == TransactionType.expense) {
        categoryExpenses[tx.categoryId] = (categoryExpenses[tx.categoryId] ?? 0.0) + tx.amount;
      }
    }

    final sortedEntries = categoryExpenses.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thống Kê Chi Tiêu',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF223B20)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Overview Metric Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tỷ lệ tiết kiệm thực tế',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF223B20)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF223B20),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${savingsRate.toStringAsFixed(1)}%',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: (savingsRate / 100).clamp(0.0, 1.0),
                      minHeight: 10,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF223B20)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn('Tổng thu', formatVND(totalIncome), const Color(0xFF2E7D32)),
                      Container(width: 1, height: 32, color: Colors.grey.shade200),
                      _buildStatColumn('Tổng chi', formatVND(totalExpense), const Color(0xFFD32F2F)),
                      Container(width: 1, height: 32, color: Colors.grey.shade200),
                      _buildStatColumn('Chênh lệch', formatVND(balance), const Color(0xFF223B20)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 2. Spending Breakdown by Category
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Phân bổ chi tiêu theo nhóm',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF223B20)),
                ),
                Text(
                  '${sortedEntries.length} danh mục',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (sortedEntries.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Center(
                  child: Text(
                    'Chưa có dữ liệu chi tiêu để phân tích.\nHãy ghi chép các khoản chi tiêu đầu tiên.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sortedEntries.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (ctx, i) {
                  final entry = sortedEntries[i];
                  final cat = provider.categories.firstWhere(
                    (c) => c.id == entry.key,
                    orElse: () => ExpenseCategory(
                      id: entry.key,
                      name: 'Chi tiêu',
                      iconName: 'category',
                      color: Colors.teal,
                      description: '',
                    ),
                  );

                  final double percentage = totalExpense > 0 ? (entry.value / totalExpense * 100) : 0;

                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 8,
                              backgroundColor: cat.color,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                cat.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                            Text(
                              formatVND(entry.value),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF223B20)),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '(${percentage.toStringAsFixed(1)}%)',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: percentage / 100,
                            minHeight: 6,
                            backgroundColor: Colors.grey.shade100,
                            valueColor: AlwaysStoppedAnimation<Color>(cat.color),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

            const SizedBox(height: 24),

            // 3. Financial Advice Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4EC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD6E6B8)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.lightbulb_rounded, color: Color(0xFF223B20), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Lời khuyên tài chính thông minh',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF223B20)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Áp dụng quy tắc 50/30/20: 50% chi tiêu thiết yếu, 30% cho sở thích & linh hoạt, 20% tích lũy quỹ dự phòng.\n'
                    '• Luôn ưu tiên nạp đầy Quỹ Khẩn Cấp (3-6 tháng chi tiêu cơ bản) trước khi đầu tư mạo hiểm.',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade800, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color)),
      ],
    );
  }
}
