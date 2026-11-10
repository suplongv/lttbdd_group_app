import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Logo biểu tượng chiếc lá chữ S của ứng dụng "Save For You"
class SaveForYouLogo extends StatelessWidget {
  final double size;
  final bool showDarkBox;
  final bool showText;
  final double fontSize;

  const SaveForYouLogo({
    super.key,
    this.size = 44,
    this.showDarkBox = false,
    this.showText = true,
    this.fontSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    final mark = CustomPaint(
      size: Size(size * (showDarkBox ? 0.56 : 0.85), size * (showDarkBox ? 0.56 : 0.85)),
      painter: _LeafSPainter(
        upperColor: showDarkBox ? const Color(0xFF9FB89B) : const Color(0xFF839E82),
        lowerColor: showDarkBox ? const Color(0xFF6B856A) : const Color(0xFF536F55),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showDarkBox)
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: AppColors.darkGreen,
              borderRadius: BorderRadius.circular(size * 0.24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkGreen.withValues(alpha: 0.18),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(child: mark),
          )
        else
          SizedBox(
            width: size,
            height: size,
            child: Center(child: mark),
          ),
        if (showText) ...[
          const SizedBox(height: 8),
          Text(
            'Save For You',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              color: AppColors.darkGreen,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ],
    );
  }
}

class _LeafSPainter extends CustomPainter {
  final Color upperColor;
  final Color lowerColor;

  _LeafSPainter({
    required this.upperColor,
    required this.lowerColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final upperPaint = Paint()
      ..color = upperColor
      ..style = PaintingStyle.fill;

    final lowerPaint = Paint()
      ..color = lowerColor
      ..style = PaintingStyle.fill;

    // Nửa lá trên tạo đường cong chữ S mềm mại
    final upperPath = Path()
      ..moveTo(w * 0.78, h * 0.08)
      ..cubicTo(w * 0.35, h * 0.08, w * 0.14, h * 0.28, w * 0.24, h * 0.48)
      ..cubicTo(w * 0.32, h * 0.56, w * 0.56, h * 0.48, w * 0.68, h * 0.36)
      ..cubicTo(w * 0.76, h * 0.27, w * 0.80, h * 0.16, w * 0.78, h * 0.08)
      ..close();

    // Nửa lá dưới đối xứng
    final lowerPath = Path()
      ..moveTo(w * 0.22, h * 0.92)
      ..cubicTo(w * 0.65, h * 0.92, w * 0.86, h * 0.72, w * 0.76, h * 0.52)
      ..cubicTo(w * 0.68, h * 0.44, w * 0.44, h * 0.52, w * 0.32, h * 0.64)
      ..cubicTo(w * 0.24, h * 0.73, w * 0.20, h * 0.84, w * 0.22, h * 0.92)
      ..close();

    canvas.drawPath(upperPath, upperPaint);
    canvas.drawPath(lowerPath, lowerPaint);
  }

  @override
  bool shouldRepaint(covariant _LeafSPainter oldDelegate) =>
      oldDelegate.upperColor != upperColor || oldDelegate.lowerColor != lowerColor;
}

