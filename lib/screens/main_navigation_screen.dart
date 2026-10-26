import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'categories_screen.dart';
import 'analytics_screen.dart';
import 'profile_screen.dart';
import 'add_entry_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    CategoriesScreen(),
    AnalyticsScreen(),
    ProfileScreen(),
  ];

  void _openAddModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const AddEntryScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddModal,
        backgroundColor: const Color(0xFF223B20),
        child: const Icon(Icons.add, color: Color(0xFFD6E6B8), size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white,
        elevation: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(index: 0, icon: Icons.home_rounded, label: 'Trang chủ'),
            _buildNavItem(index: 1, icon: Icons.grid_view_rounded, label: 'Danh mục'),
            const SizedBox(width: 48),
            _buildNavItem(index: 2, icon: Icons.bar_chart_rounded, label: 'Thống kê'),
            _buildNavItem(index: 3, icon: Icons.person_rounded, label: 'Cá nhân'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({required int index, required IconData icon, required String label}) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? const Color(0xFF223B20) : Colors.grey.shade400;

    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: color)),
          ],
        ),
      ),
    );
  }
}