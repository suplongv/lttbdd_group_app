import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/formatters.dart';
import '../providers/expense_provider.dart';
import '../models/models.dart';
import 'add_entry_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showDepositDialog(BuildContext context, ExpenseProvider provider) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nạp tiền vào Quỹ dự phòng'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nhập số tiền muốn tích lũy vào Quỹ Khẩn Cấp:'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Số tiền (₫)',
                hintText: 'VD: 500000',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF223B20),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final amt = double.tryParse(controller.text.trim().replaceAll(',', '').replaceAll('.', ''));
              if (amt != null && amt > 0) {
                provider.depositToSavings(provider.emergencyFund.id, amt);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đã nạp ${formatVND(amt)} vào ${provider.emergencyFund.name}'),
                    backgroundColor: const Color(0xFF223B20),
                  ),
                );
              }
            },
            child: const Text('Nạp ngay'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final emergencyFund = provider.emergencyFund;
    final transactions = provider.transactions;
    final quickPresets = provider.presets.take(6).toList();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sổ Chi Tiêu Thông Minh',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF223B20)),
            ),
            Text(
              formatHeaderDate(DateTime.now()),
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Color(0xFF223B20)),
            tooltip: 'Thêm thu nhập',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (ctx) => const AddEntryScreen(initialIsIncome: true),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Balance Summary Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF223B20), Color(0xFF335830)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF223B20).withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tổng số dư hiện có',
                          style: TextStyle(color: Color(0xFFD6E6B8), fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.shield_rounded, size: 14, color: Color(0xFFD6E6B8)),
                              SizedBox(width: 4),
                              Text('An toàn', style: TextStyle(color: Color(0xFFD6E6B8), fontSize: 11)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatVND(provider.balance),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.arrow_downward_rounded, size: 14, color: Color(0xFF85DCBA)),
                                    SizedBox(width: 4),
                                    Text('Thu nhập', style: TextStyle(color: Colors.white70, fontSize: 11)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatVND(provider.totalIncome),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.arrow_upward_rounded, size: 14, color: Color(0xFFE8A87C)),
                                    SizedBox(width: 4),
                                    Text('Chi tiêu', style: TextStyle(color: Colors.white70, fontSize: 11)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatVND(provider.totalExpense),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 2. Emergency Fund Tracker Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF223B20).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.savings_rounded, color: Color(0xFF223B20), size: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                emergencyFund.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF223B20)),
                              ),
                              Text(
                                'Mục tiêu: ${formatVND(emergencyFund.targetAmount)}',
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => _showDepositDialog(context, provider),
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Nạp quỹ'),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF223B20),
                            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: emergencyFund.progressPercentage / 100,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF223B20)),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Đã có: ${formatVND(emergencyFund.currentAmount)}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF223B20)),
                        ),
                        Text(
                          '${emergencyFund.progressPercentage.toStringAsFixed(1)}%',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 3. Quick Record Presets
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ghi nhanh chi tiêu',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF223B20)),
                  ),
                  Text(
                    '1-chạm ghi ngay',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 90,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: quickPresets.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (ctx, i) {
                    final preset = quickPresets[i];
                    return InkWell(
                      onTap: () {
                        provider.quickRecordPreset(preset);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Đã ghi: ${preset.name} (${formatVND(preset.price)})'),
                            backgroundColor: const Color(0xFF223B20),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        width: 145,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              preset.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    formatVND(preset.price),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF223B20),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.flash_on_rounded, size: 14, color: Colors.orange),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // 4. Recent Transactions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Giao dịch gần đây',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF223B20)),
                  ),
                  Text(
                    '${transactions.length} giao dịch',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (transactions.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.receipt_long_outlined, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 10),
                      Text(
                        'Chưa có giao dịch nào',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Bấm nút "+" bên dưới hoặc chọn ghi nhanh để thêm chi tiêu',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: transactions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (ctx, i) {
                    final tx = transactions[i];
                    final isIncome = tx.type == TransactionType.income;
                    return Dismissible(
                      key: Key(tx.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        provider.deleteTransaction(tx.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Đã xóa giao dịch: ${tx.subcategory ?? tx.categoryName}'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isIncome
                                    ? const Color(0xFF85DCBA).withOpacity(0.2)
                                    : const Color(0xFFE27D60).withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isIncome ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                                color: isIncome ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tx.subcategory ?? tx.categoryName,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  if (tx.note.isNotEmpty)
                                    Text(
                                      tx.note,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                    ),
                                  Text(
                                    formatTransactionDate(tx.date),
                                    style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${isIncome ? '+' : '-'}${formatVND(tx.amount)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: isIncome ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}