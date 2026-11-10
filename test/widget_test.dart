import 'package:flutter_test/flutter_test.dart';
import 'package:expense_planner_flutter/main.dart';

void main() {
  testWidgets('Save For You welcome and navigation smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ExpensePlannerApp());

    // Màn hình chào mừng hiển thị thương hiệu Save For You & nút Bắt đầu ngay
    expect(find.text('Save For You'), findsOneWidget);
    expect(find.text('Bắt đầu ngay'), findsOneWidget);

    // Nhấn Bắt đầu ngay để chuyển sang màn hình Đăng nhập
    await tester.tap(find.text('Bắt đầu ngay'));
    await tester.pumpAndSettle();

    expect(find.text('Chào mừng trở lại!'), findsOneWidget);
    expect(find.text('Đăng nhập'), findsOneWidget);
    expect(find.text('Đăng ký'), findsOneWidget);

    // Đăng nhập nhanh bằng tài khoản Demo
    await tester.tap(find.text('Trải nghiệm nhanh với tài khoản Demo'));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Xác minh 5 tab điều hướng chính hiển thị đúng
    expect(find.text('Trang chủ'), findsOneWidget);
    expect(find.text('Lịch'), findsOneWidget);
    expect(find.text('Ngân sách'), findsOneWidget);
    expect(find.text('Thống kê'), findsOneWidget);
    expect(find.text('Cá nhân'), findsOneWidget);
  });
}
