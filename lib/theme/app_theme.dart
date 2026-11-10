import 'package:flutter/material.dart';

/// Bảng màu & Design Tokens thống nhất cho toàn bộ ứng dụng Save For You
class AppColors {
  AppColors._();

  // Nền chính
  static const Color welcomeBg = Color(0xFFCEE2A3); // Xanh cốm nhạt màn hình Welcome
  static const Color creamBg = Color(0xFFF7FAEC); // Nền kem ngà chính của app
  static const Color headerGreen = Color(0xFF92C58E); // Header xanh lá pastel (Lịch, Ngân sách, Thống kê, Cá nhân)
  static const Color headerTitleGreen = Color(0xFF4E744B); // Chữ tiêu đề trên nền headerGreen

  // Màu thương hiệu chủ đạo (Xanh rừng đậm)
  static const Color darkGreen = Color(0xFF293B2F);
  static const Color darkGreenAlt = Color(0xFF33483A);
  static const Color greetingGreen = Color(0xFF538B67); // "Hôm nay bạn thế nào?"

  // Thẻ & Ô nhập liệu
  static const Color cardSage = Color(0xFFDFE5DE); // Card giao dịch, danh mục, cá nhân
  static const Color inputSage = Color(0xFFDDE3DC); // Ô nhập số tiền, ghi chú, khung voice
  static const Color authInputFill = Color(0xFFEFF2EB); // Ô input Login/Register
  static const Color authInputBorder = Color(0xFF6B766D);
  static const Color headerCircleBtn = Color(0xFFDDE4DA); // Nút tròn trên header xanh

  // Thanh chọn ngày & Lịch
  static const Color datePillBg = Color(0xFFE7ECBF);
  static const Color datePillText = Color(0xFF8C7E42);
  static const Color budgetGoldText = Color(0xFF9B8440);
  static const Color calendarBg = Color(0xFFE9EFD5);
  static const Color calendarHeaderBg = Color(0xFFD5D9B8);
  static const Color calendarSelected = Color(0xFFC8CB9F);
  static const Color inlineCalendarBg = Color(0xFFD4DCD3);
  static const Color inlineCalendarSelected = Color(0xFF9BD66E);
  static const Color summaryBoxBg = Color(0xFFF7F3E9);

  // Thanh điều hướng dưới (Bottom Navigation Bar)
  static const Color navBarBg = Color(0xFFEBE5DA);
  static const Color navActiveCircle = Color(0xFFF6F4EC);
  static const Color navBorder = Color(0xFFDDD6C9);

  // Màu chữ & Trạng thái
  static const Color textPrimary = Color(0xFF25352A);
  static const Color textSecondary = Color(0xFF5F6B62);
  static const Color textMuted = Color(0xFF8B948D);
  static const Color expenseRed = Color(0xFFE03E3E);
  static const Color incomeBlue = Color(0xFF2B6CE6);
  static const Color incomeGreen = Color(0xFF2E8B57);
  static const Color dividerColor = Color(0xFFC8CFC7);
}

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.darkGreen,
        primary: AppColors.darkGreen,
        secondary: AppColors.headerGreen,
        surface: AppColors.creamBg,
      ),
      scaffoldBackgroundColor: AppColors.creamBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.headerGreen,
        foregroundColor: AppColors.headerTitleGreen,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.headerTitleGreen,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkGreen,
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 13),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

