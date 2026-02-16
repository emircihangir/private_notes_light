import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:private_notes_light/features/authentication/application/app_startup.dart';
import 'package:private_notes_light/features/authentication/presentation/auth_guard.dart';
import 'package:private_notes_light/features/authentication/presentation/login_screen.dart';
import 'package:private_notes_light/features/authentication/presentation/signup_screen.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

void main() {
  group('AuthGuard works', () {
    testWidgets('Login page opens if there is a saved encryptedMasterKey', (widgetTester) async {
      // Setup
      await widgetTester.pumpWidget(
        ProviderScope(
          overrides: [appStartupProvider.overrideWith((ref) async => true)],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: AuthGuard(),
          ),
        ),
      );
      await widgetTester.pump();

      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('Signup page opens if there is no encryptedMasterKey saved', (widgetTester) async {
      // Setup
      await widgetTester.pumpWidget(
        ProviderScope(
          overrides: [appStartupProvider.overrideWith((ref) async => false)],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: AuthGuard(),
          ),
        ),
      );
      await widgetTester.pump();

      expect(find.byType(SignupScreen), findsOneWidget);
    });
  });
}
