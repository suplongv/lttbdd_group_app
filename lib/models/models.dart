import 'package:flutter/material.dart';

enum TransactionType {
  income,
  expense,
}

class TransactionItem {
  final String id;
  final String categoryId;
  final String categoryName;
  final String? subcategory;
  final double amount;
  final TransactionType type;
  final DateTime date;
  final String note;

  TransactionItem({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    this.subcategory,
    required this.amount,
    required this.type,
    required this.date,
    this.note = '',
  });
}

class ExpenseCategory {
  final String id;
  final String name;
  final String iconName;
  final Color color;
  final String description;

  ExpenseCategory({
    required this.id,
    required this.name,
    required this.iconName,
    required this.color,
    required this.description,
  });
}

class PresetItem {
  final String id;
  final String categoryId;
  final String name;
  final double price;
  final double marketPrice;
  final String unit;
  final String? description;

  PresetItem({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.marketPrice,
    this.unit = 'lần',
    this.description,
  });

  PresetItem copyWith({
    String? name,
    double? price,
    double? marketPrice,
    String? unit,
    String? description,
  }) {
    return PresetItem(
      id: id,
      categoryId: categoryId,
      name: name ?? this.name,
      price: price ?? this.price,
      marketPrice: marketPrice ?? this.marketPrice,
      unit: unit ?? this.unit,
      description: description ?? this.description,
    );
  }
}

class SavingsGoal {
  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final String? icon;
  final String note;

  SavingsGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    this.icon,
    this.note = '',
  });

  double get progressPercentage {
    if (targetAmount <= 0) return 0;
    final pct = (currentAmount / targetAmount) * 100;
    return pct > 100 ? 100 : pct;
  }

  SavingsGoal copyWith({
    String? name,
    double? targetAmount,
    double? currentAmount,
    String? icon,
    String? note,
  }) {
    return SavingsGoal(
      id: id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      icon: icon ?? this.icon,
      note: note ?? this.note,
    );
  }
}