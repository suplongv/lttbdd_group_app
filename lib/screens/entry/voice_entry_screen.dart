import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/expense_provider.dart';
import '../../theme/app_theme.dart';

class VoiceEntryScreen extends StatefulWidget {
  const VoiceEntryScreen({super.key});

  @override
  State<VoiceEntryScreen> createState() => _VoiceEntryScreenState();
}

class _VoiceEntryScreenState extends State<VoiceEntryScreen>
    with SingleTickerProviderStateMixin {
  final _textController = TextEditingController();
  late AnimationController _waveController;
  bool _isListening = true;

  static const List<double> _baseHeights = [
    22, 34, 52, 28, 62, 42, 72, 30, 56, 40, 26, 48, 22
  ];

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _toggleMic() {
    setState(() {
      _isListening = !_isListening;
      if (_isListening) {
        _waveController.repeat(reverse: true);
      } else {
        _waveController.stop();
        if (_textController.text.trim().isEmpty) {
          _textController.text = 'Ăn trưa 150k';
        }
      }
    });
  }

  void _parseAndSaveVoice() {
    final raw = _textController.text.trim();
    if (raw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nói hoặc nhập nội dung giao dịch (VD: Ăn trưa 150k)'),
        ),
      );
      return;
    }

    // Trích xuất số tiền đơn giản từ câu tiếng Việt (VD: 150k, 150.000, 2tr)
    final lower = raw.toLowerCase();
    double amount = 0;
    final regex = RegExp(r'(\d+(?:[.,]\d+)?)\s*(k|nghìn|nghin|tr|triệu|trieu|đ|d)?');
    final match = regex.firstMatch(lower);
    if (match != null) {
      final numStr = match.group(1)!.replaceAll(',', '.');
      final baseVal = double.tryParse(numStr) ?? 0;
      final unit = match.group(2) ?? '';
      if (unit == 'k' || unit == 'nghìn' || unit == 'nghin') {
        amount = baseVal * 1000;
      } else if (unit == 'tr' || unit == 'triệu' || unit == 'trieu') {
        amount = baseVal * 1000000;
      } else {
        final digitsOnly = raw.replaceAll(RegExp(r'[^0-9]'), '');
        amount = double.tryParse(digitsOnly) ?? baseVal;
      }
    }

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không nhận diện được số tiền. Hãy thử VD: "Ăn trưa 150k"'),
          backgroundColor: AppColors.expenseRed,
        ),
      );
      return;
    }

    final provider = context.read<ExpenseProvider>();
    final isIncome = lower.contains('lương') ||
        lower.contains('thưởng') ||
        lower.contains('thu nhập') ||
        lower.contains('nhận tiền');

    if (isIncome) {
      provider.addIncome(
        amount: amount,
        categoryId: 'salary',
        categoryName: 'Tiền lương',
        note: raw,
      );
    } else {
      String catId = 'other';
      String catName = 'Khác';
      if (lower.contains('ăn') || lower.contains('cơm') || lower.contains('cafe') || lower.contains('trà')) {
        catId = 'food';
        catName = 'Ăn uống';
      } else if (lower.contains('xăng') || lower.contains('xe') || lower.contains('grab')) {
        catId = 'transport';
        catName = 'Đi lại';
      } else if (lower.contains('nhà') || lower.contains('trọ')) {
        catId = 'housing';
        catName = 'Tiền nhà';
      } else if (lower.contains('điện') || lower.contains('nước')) {
        catId = 'utilities';
        catName = 'Tiền điện, nước';
      } else if (lower.contains('thuốc') || lower.contains('khám')) {
        catId = 'health';
        catName = 'Y tế';
      } else if (lower.contains('áo') || lower.contains('quần')) {
        catId = 'clothes';
        catName = 'Quần áo';
      }

      provider.addExpense(
        categoryId: catId,
        categoryName: catName,
        amount: amount,
        note: raw,
      );
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã ghi nhanh: "$raw"'),
        backgroundColor: AppColors.darkGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          child: Column(
            children: [
              // Top bar: Nút đóng (X) & Cài đặt
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.textPrimary, width: 1.4),
                      ),
                      child: const Icon(Icons.close_rounded, size: 18, color: AppColors.textPrimary),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Mẹo: Nói hoặc gõ "Ăn trưa 150k" rồi bấm Xác nhận'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.settings_outlined, color: AppColors.textPrimary, size: 24),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'Bạn muốn ghi lại\ngiao dịch gì hôm nay',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkGreen,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 28),

              // Sóng âm thanh (Waveform)
              SizedBox(
                height: 78,
                child: AnimatedBuilder(
                  animation: _waveController,
                  builder: (context, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_baseHeights.length, (index) {
                        final phase = (index % 3 == 0)
                            ? _waveController.value
                            : (1.0 - _waveController.value);
                        final factor = _isListening ? (0.65 + 0.45 * phase) : 0.75;
                        final h = (_baseHeights[index] * factor).clamp(14.0, 74.0);
                        return Container(
                          width: 4.5,
                          height: h,
                          margin: const EdgeInsets.symmetric(horizontal: 3.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF9BA79C),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),

              const SizedBox(height: 28),

              // Khung nội dung nhận diện giọng nói ("Ăn trưa 150k ...")
              Container(
                width: double.infinity,
                height: 145,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.inputSage,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        onChanged: (_) => setState(() {}),
                        maxLines: null,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Ăn trưa 150k ...',
                          hintStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: AppColors.textSecondary,
                            fontSize: 14.5,
                          ),
                        ),
                      ),
                    ),
                    if (_textController.text.trim().isNotEmpty)
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: _parseAndSaveVoice,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkGreen,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            minimumSize: Size.zero,
                          ),
                          child: const Text('Lưu giao dịch', style: TextStyle(fontSize: 12.5)),
                        ),
                      ),
                  ],
                ),
              ),

              const Spacer(),

              // Nút Mic tròn lớn phía dưới
              GestureDetector(
                onTap: _toggleMic,
                child: Container(
                  width: 78,
                  height: 78,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFC8D0C6),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.darkGreen.withValues(alpha: 0.16),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.darkGreen,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isListening ? Icons.mic_none_rounded : Icons.mic_off_outlined,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

