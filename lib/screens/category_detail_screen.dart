import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/formatters.dart';
import '../providers/expense_provider.dart';
import '../models/models.dart';

class CategoryDetailScreen extends StatelessWidget {
  final ExpenseCategory category;
  const CategoryDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final presets = provider.presets.where((p) => p.categoryId == category.id).toList();

    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: presets.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (ctx, i) {
          final item = presets[i];
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade200)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text('${formatVND(item.price)} / ${item.unit}', style: const TextStyle(color: Color(0xFF223B20), fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    provider.quickRecordPreset(item);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã ghi: ${item.name}')));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF223B20), foregroundColor: const Color(0xFFD6E6B8)),
                  child: const Text('Ghi ngay'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}