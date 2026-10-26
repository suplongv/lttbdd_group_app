import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/initial_data.dart';

class ExpenseProvider extends ChangeNotifier {
  List<TransactionItem> _transactions = List.from(initialTransactions);
  List<PresetItem> _presets = List.from(initialPresetItems);
  List<SavingsGoal> _savingsGoals = List.from(initialSavingsGoals);
  final List<ExpenseCategory> _categories = List.from(initialCategories);

  List<TransactionItem> get transactions => _transactions;
  List<PresetItem> get presets => _presets;
  List<SavingsGoal> get savingsGoals => _savingsGoals;
  List<ExpenseCategory> get categories => _categories;

  double get totalIncome => _transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => _transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get balance => totalIncome - totalExpense;

  SavingsGoal get emergencyFund {
    return _savingsGoals.firstWhere(
      (g) => g.id == 'sav-1',
      orElse: () => _savingsGoals.isNotEmpty
          ? _savingsGoals.first
          : SavingsGoal(
              id: 'sav-1',
              name: 'Quỹ Dự Phòng Khẩn Cấp (3-6 tháng)',
              targetAmount: 30000000,
              currentAmount: 0,
              icon: 'shield',
              note: 'Tiền mặt an toàn',
            ),
    );
  }

  void addIncome({required double amount, String note = 'Thu nhập', DateTime? date}) {
    if (amount <= 0) return;
    final newTx = TransactionItem(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      categoryId: 'income',
      categoryName: 'Thu nhập',
      amount: amount,
      type: TransactionType.income,
      date: date ?? DateTime.now(),
      note: note.isEmpty ? 'Thu nhập' : note,
    );
    _transactions.insert(0, newTx);
    notifyListeners();
  }

  void addExpense({
    required String categoryId,
    required String categoryName,
    required double amount,
    String? subcategory,
    String note = '',
    DateTime? date,
  }) {
    if (amount <= 0) return;
    final newTx = TransactionItem(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      categoryId: categoryId,
      categoryName: categoryName,
      subcategory: subcategory,
      amount: amount,
      type: TransactionType.expense,
      date: date ?? DateTime.now(),
      note: note,
    );
    _transactions.insert(0, newTx);
    notifyListeners();
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void quickRecordPreset(PresetItem preset) {
    final cat = _categories.firstWhere(
      (c) => c.id == preset.categoryId,
      orElse: () => ExpenseCategory(
        id: preset.categoryId,
        name: 'Chi tiêu',
        iconName: 'category',
        color: Colors.teal,
        description: '',
      ),
    );

    addExpense(
      categoryId: preset.categoryId,
      categoryName: cat.name,
      subcategory: preset.name,
      amount: preset.price,
      note: 'Ghi nhanh: ${preset.name}',
    );
  }

  void updatePresetPrice(String presetId, double newPrice) {
    final index = _presets.indexWhere((p) => p.id == presetId);
    if (index != -1) {
      _presets[index] = _presets[index].copyWith(price: newPrice);
      notifyListeners();
    }
  }

  void addPresetItem({
    required String categoryId,
    required String name,
    required double price,
    String unit = 'phần',
  }) {
    final newItem = PresetItem(
      id: 'preset_${DateTime.now().millisecondsSinceEpoch}',
      categoryId: categoryId,
      name: name,
      price: price,
      marketPrice: price,
      unit: unit,
    );
    _presets.add(newItem);
    notifyListeners();
  }

  void depositToSavings(String goalId, double amount) {
    if (amount <= 0) return;
    final index = _savingsGoals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      final goal = _savingsGoals[index];
      _savingsGoals[index] = goal.copyWith(
        currentAmount: goal.currentAmount + amount,
      );
      addExpense(
        categoryId: 'savings',
        categoryName: 'Tiết kiệm & Dự phòng',
        subcategory: goal.name,
        amount: amount,
        note: 'Tích lũy vào ${goal.name}',
      );
    }
  }

  void withdrawFromSavings(String goalId, double amount) {
    if (amount <= 0) return;
    final index = _savingsGoals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      final goal = _savingsGoals[index];
      final actualWithdrawn = amount > goal.currentAmount ? goal.currentAmount : amount;
      if (actualWithdrawn <= 0) return;
      _savingsGoals[index] = goal.copyWith(
        currentAmount: goal.currentAmount - actualWithdrawn,
      );
      addIncome(
        amount: actualWithdrawn,
        note: 'Rút từ ${goal.name}',
      );
    }
  }

  void resetToCleanDefault() {
    _transactions = [];
    _savingsGoals = [
      SavingsGoal(
        id: 'sav-1',
        name: 'Quỹ Dự Phòng Khẩn Cấp (3-6 tháng)',
        targetAmount: 30000000,
        currentAmount: 0,
        icon: 'shield',
        note: 'Tiền mặt an toàn đề phòng sự cố bất ngờ',
      ),
      SavingsGoal(
        id: 'sav-2',
        name: 'Mua sắm thiết bị & Du lịch',
        targetAmount: 15000000,
        currentAmount: 0,
        icon: 'flight',
        note: 'Tích lũy mua sắm',
      ),
    ];
    _presets = List.from(initialPresetItems);
    notifyListeners();
  }
}