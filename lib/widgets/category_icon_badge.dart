import 'package:flutter/material.dart';
import '../models/models.dart';

/// Badge icon tròn màu pastel cho từng danh mục thu/chi
class CategoryIconBadge extends StatelessWidget {
  final ExpenseCategory category;
  final double size;

  const CategoryIconBadge({
    super.key,
    required this.category,
    this.size = 40,
  });

  static IconData resolveIcon(String iconName) {
    switch (iconName) {
      case 'restaurant':
        return Icons.restaurant_rounded;
      case 'daily':
        return Icons.account_balance_wallet_outlined;
      case 'clothes':
        return Icons.checkroom_outlined;
      case 'cosmetics':
        return Icons.spa_outlined;
      case 'social':
        return Icons.wine_bar_outlined;
      case 'health':
        return Icons.local_hospital_outlined;
      case 'education':
        return Icons.school_outlined;
      case 'utilities':
        return Icons.receipt_long_outlined;
      case 'transport':
        return Icons.directions_transit_outlined;
      case 'telecom':
        return Icons.phone_in_talk_outlined;
      case 'housing':
        return Icons.home_outlined;
      case 'salary':
        return Icons.payments_outlined;
      case 'allowance':
        return Icons.savings_outlined;
      case 'bonus':
        return Icons.card_giftcard_outlined;
      case 'side_income':
        return Icons.monetization_on_outlined;
      case 'temp_income':
        return Icons.schedule_outlined;
      case 'investment':
        return Icons.trending_up_rounded;
      default:
        return Icons.more_horiz_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: category.bgColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        resolveIcon(category.iconName),
        color: category.color,
        size: size * 0.54,
      ),
    );
  }
}

