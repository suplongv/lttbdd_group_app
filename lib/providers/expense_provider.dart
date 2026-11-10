import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/initial_data.dart';

class ExpenseProvider extends ChangeNotifier {
  List<TransactionItem> _transactions = buildInitialTransactions();
  List<PresetItem> _presets = List.from(initialPresetItems);
  List<SavingsGoal> _savingsGoals = List.from(initialSavingsGoals);
  final List<ExpenseCategory> _expenseCategories = List.from(initialExpenseCategories);
  final List<ExpenseCategory> _incomeCategories = List.from(initialIncomeCategories);

  // Ngân sách theo tháng: key = 'YYYY-MM:categoryId' hoặc 'YYYY-MM:total'
  final Map<String, double> _monthlyBudgets = {};

  List<TransactionItem> get transactions => _transactions;
  List<PresetItem> get presets => _presets;
  List<SavingsGoal> get savingsGoals => _savingsGoals;
  List<ExpenseCategory> get expenseCategories => _expenseCategories;
  List<ExpenseCategory> get incomeCategories => _incomeCategories;
  List<ExpenseCategory> get categories => _expenseCategories;

  ExpenseCategory findCategory(String categoryId, {TransactionType? fallbackType}) {
    for (final c in _expenseCategories) {
      if (c.id == categoryId) return c;
    }
    for (final c in _incomeCategories) {
      if (c.id == categoryId) return c;
    }
    return ExpenseCategory(
      id: categoryId,
      name: fallbackType == TransactionType.income ? 'Thu nhập' : 'Chi tiêu',
      iconName: 'other',
      color: const Color(0xFF5C635E),
      bgColor: const Color(0xFFE3E5E3),
      type: fallbackType ?? TransactionType.expense,
    );
  }

  double get totalIncome => _transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => _transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get balance => totalIncome - totalExpense;

  // --- Ngân sách ---
  String _budgetKey(DateTime month, String categoryId) {
    final m = month.month.toString().padLeft(2, '0');
    return '${month.year}-$m:$categoryId';
  }

  double? getTotalBudget(DateTime month) {
    return _monthlyBudgets[_budgetKey(month, 'total')];
  }

  void setTotalBudget(DateTime month, double? amount) {
    final key = _budgetKey(month, 'total');
    if (amount == null || amount <= 0) {
      _monthlyBudgets.remove(key);
    } else {
      _monthlyBudgets[key] = amount;
    }
    notifyListeners();
  }

  double? getCategoryBudget(DateTime month, String categoryId) {
    return _monthlyBudgets[_budgetKey(month, categoryId)];
  }

  void setCategoryBudget(DateTime month, String categoryId, double? amount) {
    final key = _budgetKey(month, categoryId);
    if (amount == null || amount <= 0) {
      _monthlyBudgets.remove(key);
    } else {
      _monthlyBudgets[key] = amount;
    }
    notifyListeners();
  }

  // --- Truy vấn theo thời gian ---
  List<TransactionItem> transactionsForDate(DateTime date) {
    return _transactions
        .where((t) => t.date.year == date.year && t.date.month == date.month && t.date.day == date.day)
        .toList();
  }

  List<TransactionItem> transactionsForMonth(DateTime month) {
    return _transactions
        .where((t) => t.date.year == month.year && t.date.month == month.month)
        .toList();
  }

  List<TransactionItem> transactionsForYear(int year) {
    return _transactions.where((t) => t.date.year == year).toList();
  }

  double expenseForCategoryInMonth(String categoryId, DateTime month) {
    return _transactions
        .where((t) =>
            t.type == TransactionType.expense &&
            t.categoryId == categoryId &&
            t.date.year == month.year &&
            t.date.month == month.month)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double totalExpenseInMonth(DateTime month) {
    return _transactions
        .where((t) =>
            t.type == TransactionType.expense &&
            t.date.year == month.year &&
            t.date.month == month.month)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double totalIncomeInMonth(DateTime month) {
    return _transactions
        .where((t) =>
            t.type == TransactionType.income &&
            t.date.year == month.year &&
            t.date.month == month.month)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  // --- Thêm / Xóa giao dịch ---
  void addIncome({
    required double amount,
    String categoryId = 'salary',
    String categoryName = 'Tiền lương',
    String note = '',
    DateTime? date,
  }) {
    if (amount <= 0) return;
    final newTx = TransactionItem(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      categoryId: categoryId,
      categoryName: categoryName,
      amount: amount,
      type: TransactionType.income,
      date: date ?? DateTime.now(),
      note: note,
    );
    _transactions.insert(0, newTx);
    _transactions.sort((a, b) => b.date.compareTo(a.date));
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
    _transactions.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void quickRecordPreset(PresetItem preset) {
    final cat = findCategory(preset.categoryId);
    addExpense(
      categoryId: preset.categoryId,
      categoryName: cat.name,
      subcategory: preset.name,
      amount: preset.price,
      note: preset.name,
    );
  }

  void depositToSavings(String goalId, double amount) {
    if (amount <= 0) return;
    final index = _savingsGoals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      final goal = _savingsGoals[index];
      _savingsGoals[index] = goal.copyWith(currentAmount: goal.currentAmount + amount);
      addExpense(
        categoryId: 'other',
        categoryName: 'Tiết kiệm',
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
      _savingsGoals[index] = goal.copyWith(currentAmount: goal.currentAmount - actualWithdrawn);
      addIncome(
        amount: actualWithdrawn,
        categoryId: 'investment',
        categoryName: 'Rút tiết kiệm',
        note: 'Rút từ ${goal.name}',
      );
    }
  }

  void resetToCleanDefault() {
    _transactions = [];
    _monthlyBudgets.clear();
    _savingsGoals = List.from(initialSavingsGoals);
    _presets = List.from(initialPresetItems);
    notifyListeners();
  }
}
