
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sasha_botique/features/auth/domain/repositories/auth_repository.dart';
import 'package:sasha_botique/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:sasha_botique/main.dart';

void main() {
  // IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow Integration Tests', () {
    testWidgets('complete auth flow - login, check status, logout',
            (WidgetTester tester) async {
          // Start app
          await tester.pumpWidget(MyApp());
          await tester.pumpAndSettle();

          // Verify initial unauthenticated state
          expect(find.text('Login'), findsOneWidget);

          // Enter login credentials
          await tester.enterText(
              find.byKey(Key('email_field')), 'test@example.com');
          await tester.enterText(
              find.byKey(Key('password_field')), 'password123');

          // Tap login button
          await tester.tap(find.byKey(Key('login_button')));
          await tester.pumpAndSettle();

          // Verify successful login
          expect(find.text('Welcome'), findsOneWidget);

          // Verify authenticated state
          expect(find.text('Dashboard'), findsOneWidget);

          // Perform logout
          await tester.tap(find.byKey(Key('logout_button')));
          await tester.pumpAndSettle();

          // Verify return to login screen
          expect(find.text('Login'), findsOneWidget);
        });

    testWidgets('signup flow', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      // Navigate to signup
      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      // Fill signup form
      await tester.enterText(
          find.byKey(Key('signup_name_field')), 'Test User');
      await tester.enterText(
          find.byKey(Key('signup_email_field')), 'new@example.com');
      await tester.enterText(
          find.byKey(Key('signup_password_field')), 'newpassword123');

      // Submit signup
      await tester.tap(find.byKey(Key('signup_button')));
      await tester.pumpAndSettle();

      // Verify redirect to login
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('forgot password flow', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      // Navigate to forgot password
      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      // Enter email
      await tester.enterText(
          find.byKey(Key('forgot_password_email_field')),
          'test@example.com'
      );

      // Submit request
      await tester.tap(find.byKey(Key('reset_password_button')));
      await tester.pumpAndSettle();

      // Verify success message
      expect(find.text('Password reset email sent'), findsOneWidget);
    });
  });
}