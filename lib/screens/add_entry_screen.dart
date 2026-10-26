import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../models/models.dart';

class AddEntryScreen extends StatefulWidget {
  final bool initialIsIncome;

  const AddEntryScreen({super.key, this.initialIsIncome = false});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  late bool _isIncome;
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _isIncome = widget.initialIsIncome;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _saveEntry() {
    final amountText = _amountController.text.trim().replaceAll(',', '').replaceAll('.', '');
    final amount = double.tryParse(amountText);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập số tiền hợp lệ lớn hơn 0'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final provider = context.read<ExpenseProvider>();
    final note = _noteController.text.trim();

    if (_isIncome) {
      provider.addIncome(
        amount: amount,
        note: note.isEmpty ? 'Thu nhập' : note,
        date: _selectedDate,
      );
    } else {
      final categoryId = _selectedCategoryId ?? (provider.categories.isNotEmpty ? provider.categories.first.id : 'other');
      final category = provider.categories.firstWhere(
        (c) => c.id == categoryId,
        orElse: () => ExpenseCategory(
          id: categoryId,
          name: 'Chi tiêu',
          iconName: 'category',
          color: Colors.teal,
          description: '',
        ),
      );

      provider.addExpense(
        categoryId: category.id,
        categoryName: category.name,
        amount: amount,
        note: note,
        date: _selectedDate,
      );
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isIncome ? 'Đã thêm thu nhập thành công!' : 'Đã thêm chi tiêu thành công!'),
        backgroundColor: const Color(0xFF223B20),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<ExpenseProvider>().categories;
    if (_selectedCategoryId == null && categories.isNotEmpty) {
      _selectedCategoryId = categories.first.id;
    }

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              _isIncome ? 'Thêm Khoản Thu Nhập' : 'Thêm Khoản Chi Tiêu',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF223B20),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Chi tiêu')),
                    selected: !_isIncome,
                    selectedColor: const Color(0xFF223B20),
                    labelStyle: TextStyle(
                      color: !_isIncome ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (val) => setState(() => _isIncome = false),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Thu nhập')),
                    selected: _isIncome,
                    selectedColor: const Color(0xFF223B20),
                    labelStyle: TextStyle(
                      color: _isIncome ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (val) => setState(() => _isIncome = true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                labelText: 'Số tiền',
                hintText: 'VD: 50000',
                suffixText: '₫',
                suffixStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: const Color(0xFFF8FAF7),
              ),
            ),
            if (!_isIncome) ...[
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: _selectedCategoryId,
                decoration: InputDecoration(
                  labelText: 'Danh mục chi tiêu',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: const Color(0xFFF8FAF7),
                ),
                items: categories.map((cat) {
                  return DropdownMenuItem(
                    value: cat.id,
                    child: Text(cat.name),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedCategoryId = val),
              ),
            ],
            const SizedBox(height: 14),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Ghi chú',
                hintText: _isIncome ? 'VD: Tiền lương, thưởng...' : 'VD: Mua trà sữa, xăng...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: const Color(0xFFF8FAF7),
              ),
            ),
            const SizedBox(height: 14),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFF8FAF7),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 20, color: Color(0xFF223B20)),
                    const SizedBox(width: 10),
                    Text(
                      'Ngày: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF223B20),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _saveEntry,
              child: const Text('Lưu giao dịch', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
