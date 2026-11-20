import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilara/screens/home_screen.dart';

void main() {
  testWidgets('shows the Pilala action on the Home screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    expect(find.text('Pilala'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
