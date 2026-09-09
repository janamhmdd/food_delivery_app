import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery_app/core/di/service_locator.dart';
import 'package:food_delivery_app/features/auth/ui/login_screen.dart';
import 'package:food_delivery_app/features/auth/ui/set_fingerprint_screen.dart';
import 'package:food_delivery_app/features/auth/ui/set_password_screen.dart';
import 'package:food_delivery_app/features/auth/ui/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    setupGetIt();
  });

  testWidgets('LoginScreen renders correctly matching Figma design', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Hello!'), findsOneWidget);
    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('Email or Mobile Number'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Forget Password'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.byIcon(Icons.fingerprint), findsOneWidget);
    expect(find.byIcon(Icons.home_outlined), findsOneWidget);
  });

  testWidgets('SignUpScreen renders correctly matching Figma design', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SignUpScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('New Account'), findsOneWidget);
    expect(find.text('Full name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Mobile Number'), findsOneWidget);
    expect(find.text('Date of birth'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('or sign up with'), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);
  });

  testWidgets('SetPasswordScreen renders correctly matching Figma design', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SetPasswordScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Set Password'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);
    expect(find.text('Create New Password'), findsOneWidget);
  });

  testWidgets('SetFingerprintScreen renders correctly matching Figma 2-E and 2-F', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SetFingerprintScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Set Your Fingerprint'), findsOneWidget);
    expect(find.textContaining('Lorem ipsum'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.byIcon(Icons.home_outlined), findsOneWidget);

    // Tap fingerprint 4 times to complete setup (transitioning from 2-E to 2-F)
    for (int i = 0; i < 4; i++) {
      await tester.tap(find.byKey(const Key('fingerprint_target')));
      await tester.pumpAndSettle();
    }

    expect(find.text('Fingerprint captured successfully!'), findsOneWidget);
    expect(find.text('Fingerprint registered ✓'), findsOneWidget);
  });
}
