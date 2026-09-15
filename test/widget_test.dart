import 'package:flutter_test/flutter_test.dart';

import 'package:sales_app/main.dart';

void main() {
  testWidgets('app boots to the splash screen without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const SalesRepApp());
    expect(find.text('Sales Rep'), findsOneWidget);
  });
}
