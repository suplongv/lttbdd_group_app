import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Thanh Bottom Navigation 5 tab với hiệu ứng nút tròn nổi lên cho tab đang hoạt động
class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<_NavSpec> _items = [
    _NavSpec(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Trang chủ'),
    _NavSpec(icon: Icons.calendar_today_outlined, activeIcon: Icons.calendar_month_rounded, label: 'Lịch'),
    _NavSpec(icon: Icons.account_balance_wallet_outlined, activeIcon: Icons.account_balance_wallet_rounded, label: 'Ngân sách'),
    _NavSpec(icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart_rounded, label: 'Thống kê'),
    _NavSpec(icon: Icons.account_circle_outlined, activeIcon: Icons.account_circle_rounded, label: 'Cá nhân'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      height: 70 + bottomInset,
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: AppColors.navBarBg,
        border: Border(
          top: BorderSide(color: AppColors.navBorder, width: 0.8),
        ),
      ),
      child: Row(
        children: List.generate(_items.length, (index) {
          final item = _items[index];
          final isSelected = currentIndex == index;

          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTap(index),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  if (isSelected)
                    Positioned(
                      top: -12,
                      child: Container(
                        width: 66,
                        height: 66,
                        decoration: BoxDecoration(
                          color: AppColors.navActiveCircle,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.navBorder, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              item.activeIcon,
                              size: 22,
                              color: AppColors.darkGreen,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.darkGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 6),
                        Icon(
                          item.icon,
                          size: 22,
                          color: AppColors.textPrimary,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavSpec {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavSpec({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

