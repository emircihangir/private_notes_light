import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:private_notes_light/features/authentication/presentation/signup_screen.dart';
import 'package:private_notes_light/features/notes/presentation/notes_page.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';
import 'package:private_notes_light/main.dart';

const dummyPasword = 'StrongPassword123';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  timeDilation = 0.5;

  testWidgets('Integration test', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();

    // WelcomePage
    for (int i = 0; i < 3; i++) {
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
    }

    // SignupScreen
    expect(find.byType(SignupScreen), findsOne);

    Element context = tester.element(find.byType(SignupScreen));

    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(find.text(AppLocalizations.of(context)!.passwordEmptyError), findsAtLeast(1));

    final passwordTextFields = find.byType(TextFormField);
    expect(passwordTextFields, findsNWidgets(2));

    await tester.enterText(passwordTextFields.at(0), dummyPasword);
    await tester.enterText(passwordTextFields.at(1), dummyPasword);
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(find.byType(NotesPage), findsOne);

    // NotesPage
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // EditNoteView
    context = tester.element(find.byType(Scaffold));
    expect(find.text(AppLocalizations.of(context)!.titleWarning), findsOne);
    final textFields = find.byType(TextFormField);
    const dummyTitle = 'Note 1';
    await tester.enterText(textFields.at(0), dummyTitle);
    await tester.enterText(textFields.at(1), 'Some note content hahaha');
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.check_rounded));
    await tester.pumpAndSettle();

    // NotesPage
    expect(find.text(dummyTitle), findsOne);
    context = tester.element(find.byType(Scaffold));
    expect(find.text(AppLocalizations.of(context)!.exportSuggestionSnackbar), findsOne);

    await tester.fling(find.text(dummyTitle), const Offset(-300, 0), 1000.0);
    await tester.pumpAndSettle();
  });

  timeDilation = 1;
}
