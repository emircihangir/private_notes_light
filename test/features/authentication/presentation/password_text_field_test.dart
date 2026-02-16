import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:private_notes_light/features/authentication/presentation/login_screen.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

void main() {
  testWidgets('Password text field invalidates empty text', (widgetTester) async {
    // Setup
    await widgetTester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: LoginScreen(),
        ),
      ),
    );
    await widgetTester.pumpAndSettle();
    final context = widgetTester.element(find.byType(LoginScreen));

    // Act
    await widgetTester.tap(find.byType(FilledButton));
    await widgetTester.pumpAndSettle();

    // Verify
    expect(find.text(AppLocalizations.of(context)!.passwordEmptyError), findsOneWidget);
  });
}
