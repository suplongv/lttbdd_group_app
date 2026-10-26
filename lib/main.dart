import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/expense_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ExpensePlannerApp());
}

class ExpensePlannerApp extends StatelessWidget {
  const ExpensePlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
      ],
      child: MaterialApp(
        title: 'Sổ Chi Tiêu & Quỹ Tiết Kiệm Thông Minh',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF223B20),
            primary: const Color(0xFF223B20),
            secondary: const Color(0xFFD6E6B8),
            surface: Colors.white,
          ),
          scaffoldBackgroundColor: const Color(0xFFF8FAF7),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF223B20),
            elevation: 0,
            centerTitle: false,
          ),
        ),
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            if (auth.isAuthenticated) {
              return const MainNavigationScreen();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}