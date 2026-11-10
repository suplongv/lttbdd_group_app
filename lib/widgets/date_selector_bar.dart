import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

/// Thanh chọn ngày/tháng màu vàng nhạt "< 16/10/2026 ( Thứ 6 ) >"
class DateSelectorBar extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback? onTapDate;
  final String? customLabel;

  const DateSelectorBar({
    super.key,
    required this.selectedDate,
    required this.onPrevious,
    required this.onNext,
    this.onTapDate,
    this.customLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.datePillBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onPrevious,
            icon: const Icon(Icons.chevron_left_rounded, size: 22),
            color: AppColors.datePillText,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          Expanded(
            child: InkWell(
              onTap: onTapDate,
              borderRadius: BorderRadius.circular(16),
              child: Center(
                child: Text(
                  customLabel ?? formatPillDate(selectedDate),
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.datePillText,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: onNext,
            icon: const Icon(Icons.chevron_right_rounded, size: 22),
            color: AppColors.datePillText,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }
}

