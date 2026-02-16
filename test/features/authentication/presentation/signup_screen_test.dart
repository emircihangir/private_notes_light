import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:private_notes_light/features/authentication/presentation/signup_screen.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

void main() {
  testWidgets('Signup page detects failed password confirmation', (widgetTester) async {
    // Setup
    await widgetTester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SignupScreen(),
        ),
      ),
    );
    await widgetTester.pumpAndSettle();
    final context = widgetTester.element(find.byType(SignupScreen));

    // Act
    await widgetTester.enterText(find.byType(TextField).first, 'dummy password');
    await widgetTester.pumpAndSettle();

    await widgetTester.enterText(find.byType(TextField).last, 'different dummy password');
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(find.byType(FilledButton));
    await widgetTester.pumpAndSettle();

    expect(find.text(AppLocalizations.of(context)!.passwordsDontMatch), findsOneWidget);
  });
}
