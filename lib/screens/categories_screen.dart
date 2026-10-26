import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import 'category_detail_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  IconData _getCategoryIcon(String iconName) {
    switch (iconName) {
      case 'restaurant':
        return Icons.restaurant_rounded;
      case 'directions_car':
        return Icons.directions_car_rounded;
      case 'shopping_bag':
        return Icons.shopping_bag_rounded;
      case 'home':
        return Icons.home_rounded;
      case 'local_hospital':
        return Icons.local_hospital_rounded;
      case 'school':
        return Icons.school_rounded;
      case 'card_giftcard':
        return Icons.card_giftcard_rounded;
      case 'savings':
        return Icons.savings_rounded;
      default:
        return Icons.more_horiz_rounded;
    }
  }

  void _showAddPresetDialog(BuildContext context, ExpenseProvider provider) {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final unitCtrl = TextEditingController(text: 'lần');
    String selectedCatId = provider.categories.isNotEmpty ? provider.categories.first.id : 'food';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Thêm mục chi tiêu mẫu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedCatId,
                  decoration: const InputDecoration(labelText: 'Danh mục', border: OutlineInputBorder()),
                  items: provider.categories.map((c) {
                    return DropdownMenuItem(value: c.id, child: Text(c.name));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => selectedCatId = val);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Tên mục (VD: Cơm trưa, Xăng...)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Giá mặc định (₫)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: unitCtrl,
                  decoration: const InputDecoration(labelText: 'Đơn vị tính (phần, ly, lần...)', border: OutlineInputBorder()),
                ),
              ],
            ),
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
                final name = nameCtrl.text.trim();
                final price = double.tryParse(priceCtrl.text.trim().replaceAll(',', '').replaceAll('.', ''));
                if (name.isNotEmpty && price != null && price > 0) {
                  provider.addPresetItem(
                    categoryId: selectedCatId,
                    name: name,
                    price: price,
                    unit: unitCtrl.text.trim().isEmpty ? 'lần' : unitCtrl.text.trim(),
                  );
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã thêm mục "$name"'),
                      backgroundColor: const Color(0xFF223B20),
                    ),
                  );
                }
              },
              child: const Text('Thêm'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final categories = provider.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Danh Mục Chi Tiêu',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF223B20)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.playlist_add_rounded, color: Color(0xFF223B20)),
            tooltip: 'Thêm mục mẫu',
            onPressed: () => _showAddPresetDialog(context, provider),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (ctx, i) {
          final cat = categories[i];
          final presetCount = provider.presets.where((p) => p.categoryId == cat.id).length;

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoryDetailScreen(category: cat),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: cat.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getCategoryIcon(cat.iconName),
                      color: cat.color,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cat.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          cat.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F4EC),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$presetCount mục',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF223B20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
