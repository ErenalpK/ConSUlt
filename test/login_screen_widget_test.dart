import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:consult/screens/login_screen.dart';

void main() {
  testWidgets('LoginScreen shows validation errors when fields are empty',
          (WidgetTester tester) async {
        // Pump only the LoginScreen (no Firebase init, no app main)
        await tester.pumpWidget(
          MaterialApp(
            home: const LoginScreen(),
            routes: {
              // Routes exist so Navigator calls won't crash if triggered.
              '/signup': (_) => const Scaffold(body: Text('Signup Page')),
              '/home': (_) => const Scaffold(body: Text('Home Page')),
            },
          ),
        );

        // Tap the Continue button without entering anything
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();

        // Expect both validator messages
        expect(find.text('Email cannot be empty'), findsOneWidget);
        expect(find.text('Password cannot be empty'), findsOneWidget);
      });
}
