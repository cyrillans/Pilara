import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilara/screens/signin_screen.dart';

void main() {
  testWidgets('sign-in screen renders its welcome heading', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SignInScreen()),
    );

    expect(find.text('Selamat Datang Kembali'), findsOneWidget);
  });
}
