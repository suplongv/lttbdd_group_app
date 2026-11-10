import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';
import 'home/home_screen.dart';
import 'calendar/calendar_screen.dart';
import 'budget/budget_screen.dart';
import 'analytics/analytics_screen.dart';
import 'profile/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      HomeScreen(
        onSeeAllTransactions: () => setState(() => _currentIndex = 1),
      ),
      const CalendarScreen(),
      const BudgetScreen(),
      const AnalyticsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
