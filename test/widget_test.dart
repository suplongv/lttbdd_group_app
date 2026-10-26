import 'package:flutter_test/flutter_test.dart';
import 'package:expense_planner_flutter/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ExpensePlannerApp());

    // Verify that the app title or main screen is present
    expect(find.byType(ExpensePlannerApp), findsOneWidget);
  });
}
