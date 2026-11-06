import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pilara/main.dart';
import 'package:pilara/screens/splash_screen.dart';

void main() {
  testWidgets('app starts on the Pilara splash screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
