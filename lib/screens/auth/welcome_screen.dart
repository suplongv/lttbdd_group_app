import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/save_for_you_logo.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.welcomeBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            children: [
              const SizedBox(height: 24),
              const SaveForYouLogo(
                size: 74,
                showDarkBox: true,
                fontSize: 19,
              ),
              const Spacer(),
              const Text(
                'Hiểu tiền của bạn\nTiết kiệm theo cách riêng',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkGreen,
                  height: 1.28,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Theo dõi thu chi, hiểu thói quen tài chính\nvà từng bước chạm đến mục tiêu của bạn',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  color: AppColors.darkGreen.withValues(alpha: 0.78),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 44),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Bắt đầu ngay',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Quản lý tiền theo cách của bạn',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.darkGreen.withValues(alpha: 0.72),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

