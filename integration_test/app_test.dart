import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path/path.dart' as path;
import 'package:private_notes_light/features/authentication/presentation/login_screen.dart';
import 'package:private_notes_light/features/authentication/presentation/signup_screen.dart';
import 'package:private_notes_light/features/backup/application/export_service.dart';
import 'package:private_notes_light/features/notes/presentation/notes_page.dart';
import 'package:private_notes_light/features/settings/presentation/settings_page.dart';
import 'package:private_notes_light/features/welcome/presentation/welcome_page.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';
import 'package:private_notes_light/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

const initialPassword = 'StrongPassword123';
const changedPassword = 'EvenStrongerPassword456';
const firstNoteTitle = 'Alpha travel plans';
const firstNoteUpdatedTitle = 'Alpha travel plans updated';
const firstNoteContent = 'Book the train and pack the passport.';
const firstNoteUpdatedContent = 'Book the train, pack the passport, and print tickets.';
const secondNoteTitle = 'Beta grocery list';
const secondNoteContent = 'Coffee, oats, spinach, and lemons.';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  timeDilation = 1;

  setUp(() async {
    await _resetPersistentAppState();
  });

  tearDown(() {
    timeDilation = 1;
  });

  testWidgets('complete first-run private notes journey', (tester) async {
    await tester.pumpWidget(
      ProviderScope(overrides: [exportServiceProvider.overrideWith((ref) async => true)], child: const App()),
    );
    await _pumpUntilFound(tester, find.byType(WelcomePage));

    final l10n = _l10n(tester);

    await _completeWelcomeFlow(tester, l10n);
    await _signUp(tester, l10n);
    await _createFirstNoteFromEmptyState(tester, l10n);
    await _createSecondNoteFromFab(tester, l10n);
    await _searchNotes(tester, l10n);
    await _viewAndEditFirstNote(tester, l10n);
    await _moveSecondNoteToTrashAndRestore(tester, l10n);
    await _exerciseSettings(tester, l10n);
    await _verifyNoExportSuggestionAfterDisabled(tester, l10n);
    await _verifyLoginWithChangedPassword(tester, l10n);
  });
}

Future<void> _resetPersistentAppState() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  final databasesPath = await getDatabasesPath();
  await deleteDatabase(path.join(databasesPath, 'private_notes.db'));
}

AppLocalizations _l10n(WidgetTester tester) {
  return AppLocalizations.of(tester.element(find.byType(Scaffold).last))!;
}

Future<void> _pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 8),
}) async {
  final endTime = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(endTime)) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isNotEmpty) return;
  }

  expect(finder, findsWidgets);
}

Future<void> _tapAndSettle(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _pageBackAndSettle(WidgetTester tester) async {
  await tester.pageBack();
  await tester.pumpAndSettle();
}

Future<void> _scrollUntilVisible(WidgetTester tester, Finder finder) async {
  if (finder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(finder, 250, scrollable: find.byType(Scrollable).last);
  }
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
}

Future<void> _completeWelcomeFlow(WidgetTester tester, AppLocalizations l10n) async {
  expect(find.text(l10n.slide1Title), findsOneWidget);

  await _tapAndSettle(tester, find.text(l10n.next));
  expect(find.text(l10n.slide2Title), findsOneWidget);

  await _tapAndSettle(tester, find.text(l10n.next));
  expect(find.text(l10n.slide3Title), findsOneWidget);

  await _tapAndSettle(tester, find.text(l10n.getStarted));
  await _pumpUntilFound(tester, find.byType(SignupScreen));
}

Future<void> _signUp(WidgetTester tester, AppLocalizations l10n) async {
  expect(find.byType(SignupScreen), findsOneWidget);

  await _tapAndSettle(tester, find.text(l10n.signupButton));
  expect(find.text(l10n.passwordEmptyError), findsNWidgets(2));

  final passwordFields = find.byType(TextFormField);
  expect(passwordFields, findsNWidgets(2));

  await tester.enterText(passwordFields.at(0), initialPassword);
  await tester.enterText(passwordFields.at(1), 'Not$initialPassword');
  await _tapAndSettle(tester, find.text(l10n.signupButton));
  expect(find.text(l10n.passwordsDontMatch), findsOneWidget);

  await tester.enterText(passwordFields.at(0), initialPassword);
  await tester.enterText(passwordFields.at(1), initialPassword);
  await _tapAndSettle(tester, find.text(l10n.signupButton));
  await _pumpUntilFound(tester, find.byType(NotesPage));

  expect(find.text(l10n.noNotesTitle), findsOneWidget);
}

Future<void> _createFirstNoteFromEmptyState(WidgetTester tester, AppLocalizations l10n) async {
  await _tapAndSettle(tester, find.text(l10n.createNoteButton));
  expect(find.text(l10n.createNoteTitle), findsOneWidget);

  await _tapAndSettle(tester, find.byIcon(Icons.check_rounded));
  expect(find.text(l10n.titleEmptyError), findsOneWidget);
  expect(find.text(l10n.contentEmptyError), findsOneWidget);

  expect(find.text(l10n.titleWarning), findsOneWidget);
  await _tapAndSettle(tester, find.text(l10n.dontShowAgain));
  expect(find.text(l10n.titleWarning), findsNothing);

  await _fillCurrentNoteForm(tester, title: firstNoteTitle, content: firstNoteContent);
  await _tapAndSettle(tester, find.byIcon(Icons.check_rounded));
  await _pumpUntilFound(tester, find.byType(NotesPage));

  expect(find.text(firstNoteTitle), findsOneWidget);
  expect(find.text(l10n.exportSuggestionSnackbar), findsOneWidget);

  await _tapAndSettle(tester, find.text(l10n.export));
  expect(find.text(l10n.exportSuccess), findsOneWidget);
}

Future<void> _createSecondNoteFromFab(WidgetTester tester, AppLocalizations l10n) async {
  await _tapAndSettle(tester, find.byType(FloatingActionButton));
  expect(find.text(l10n.createNoteTitle), findsOneWidget);
  expect(find.text(l10n.titleWarning), findsNothing);

  await _fillCurrentNoteForm(tester, title: secondNoteTitle, content: secondNoteContent);
  await _tapAndSettle(tester, find.byIcon(Icons.check_rounded));
  await _pumpUntilFound(tester, find.byType(NotesPage));

  expect(find.text(firstNoteTitle), findsOneWidget);
  expect(find.text(secondNoteTitle), findsOneWidget);
}

Future<void> _fillCurrentNoteForm(WidgetTester tester, {required String title, required String content}) async {
  final textFields = find.byType(TextFormField);
  expect(textFields, findsNWidgets(2));

  await tester.enterText(find.descendant(of: textFields.at(0), matching: find.byType(EditableText)), title);
  await tester.enterText(find.descendant(of: textFields.at(1), matching: find.byType(EditableText)), content);
  await tester.pumpAndSettle();
}

Future<void> _searchNotes(WidgetTester tester, AppLocalizations l10n) async {
  final searchField = find.descendant(of: find.byType(SearchBar), matching: find.byType(EditableText));

  await tester.enterText(searchField, 'alpha');
  await tester.pumpAndSettle();
  expect(find.text(firstNoteTitle), findsOneWidget);
  expect(find.text(secondNoteTitle), findsNothing);

  await tester.enterText(searchField, 'not present');
  await tester.pumpAndSettle();
  expect(find.text(l10n.noNotesFound), findsOneWidget);

  await tester.enterText(searchField, '');
  await tester.pumpAndSettle();
  expect(find.text(firstNoteTitle), findsOneWidget);
  expect(find.text(secondNoteTitle), findsOneWidget);
}

Future<void> _viewAndEditFirstNote(WidgetTester tester, AppLocalizations l10n) async {
  await _tapAndSettle(tester, find.text(firstNoteTitle));
  expect(find.text(firstNoteContent), findsOneWidget);

  await _tapAndSettle(tester, find.byIcon(Icons.edit_rounded));
  expect(find.text(l10n.editNoteTitle), findsOneWidget);
  expect(find.text(l10n.titleWarning), findsNothing);

  await _fillCurrentNoteForm(tester, title: firstNoteUpdatedTitle, content: firstNoteUpdatedContent);
  await _tapAndSettle(tester, find.byIcon(Icons.check_rounded));

  expect(find.text(firstNoteUpdatedTitle), findsAtLeast(1));
  expect(find.text(firstNoteUpdatedContent), findsOneWidget);

  await _pageBackAndSettle(tester);
  await _pumpUntilFound(tester, find.byType(NotesPage));
  expect(find.text(firstNoteUpdatedTitle), findsOneWidget);
}

Future<void> _moveSecondNoteToTrashAndRestore(WidgetTester tester, AppLocalizations l10n) async {
  await tester.fling(find.text(secondNoteTitle), const Offset(-500, 0), 1200);
  await tester.pumpAndSettle();
  expect(find.text(secondNoteTitle), findsNothing);
  expect(find.text(l10n.noteDeleted), findsOneWidget);

  await _tapAndSettle(tester, find.text(l10n.undo));
  expect(find.text(secondNoteTitle), findsOneWidget);

  await tester.fling(find.text(secondNoteTitle), const Offset(-500, 0), 1200);
  await tester.pumpAndSettle();
  expect(find.text(secondNoteTitle), findsNothing);

  await _tapAndSettle(tester, find.byIcon(Icons.delete_outline_rounded));
  expect(find.text(l10n.trashedNotes), findsOneWidget);
  expect(find.text(secondNoteTitle), findsOneWidget);

  await _tapAndSettle(tester, find.text(l10n.putBack));
  // await _pageBackAndSettle(tester);
  await tester.tapAt(const Offset(10, 10));
  await tester.pumpAndSettle();

  expect(find.text(secondNoteTitle), findsOneWidget);
  expect(find.byIcon(Icons.delete_outline_rounded), findsNothing);
}

Future<void> _exerciseSettings(WidgetTester tester, AppLocalizations l10n) async {
  await _tapAndSettle(tester, find.byIcon(Icons.settings_outlined));
  await _pumpUntilFound(tester, find.byType(SettingsPage));

  await _tapAndSettle(tester, find.text(l10n.exportDataTitle));
  expect(find.text(l10n.exportSuccess), findsOneWidget);

  await _tapAndSettle(tester, find.text(l10n.importDataTitle));
  expect(find.text(l10n.areYouSure), findsOneWidget);
  await _tapAndSettle(tester, find.text(l10n.cancel));

  await _tapAndSettle(tester, find.byIcon(Icons.help_outline_rounded).first);
  expect(find.text(l10n.exportSuggestionsHelpText), findsOneWidget);
  await _tapAndSettle(tester, find.text(l10n.ok));

  await _tapAndSettle(tester, find.text(l10n.exportSuggestions));
  await _tapAndSettle(tester, find.text(l10n.exportWarnings));

  await _changePassword(tester, l10n);

  await _setDropdownValue(tester, currentValue: l10n.themeSystem, newValue: l10n.themeDark);
  expect(find.text(l10n.themeDark), findsOneWidget);

  await _pageBackAndSettle(tester);
  await _pumpUntilFound(tester, find.byType(NotesPage));

  await _verifyEverySortingOption(tester, l10n);
}

Future<void> _setDropdownValue(WidgetTester tester, {required String currentValue, required String newValue}) async {
  final currentValueFinder = find.text(currentValue).last;
  await _scrollUntilVisible(tester, currentValueFinder);
  await _tapAndSettle(tester, currentValueFinder);
  await _tapAndSettle(tester, find.text(newValue).last);
}

Future<void> _changePassword(WidgetTester tester, AppLocalizations l10n) async {
  final changePasswordTile = find.text(l10n.changePassword);
  await _scrollUntilVisible(tester, changePasswordTile);
  await _tapAndSettle(tester, changePasswordTile);

  expect(find.text(l10n.newPasswordWarning), findsOneWidget);
  await _tapAndSettle(tester, find.text(l10n.submitButton));
  expect(find.text(l10n.passwordEmptyError), findsNWidgets(2));

  final passwordFields = find.byType(TextFormField);
  expect(passwordFields, findsNWidgets(2));

  await tester.enterText(passwordFields.at(0), changedPassword);
  await tester.enterText(passwordFields.at(1), 'Not$changedPassword');
  await _tapAndSettle(tester, find.text(l10n.submitButton));
  expect(find.text(l10n.passwordsDontMatch), findsOneWidget);

  await tester.enterText(passwordFields.at(0), changedPassword);
  await tester.enterText(passwordFields.at(1), changedPassword);
  await _tapAndSettle(tester, find.text(l10n.submitButton));
  expect(find.text(l10n.newPasswordWarning), findsNothing);
}

Future<void> _verifyLoginWithChangedPassword(WidgetTester tester, AppLocalizations l10n) async {
  await _tapAndSettle(tester, find.byIcon(Icons.logout_rounded));
  await _pumpUntilFound(tester, find.byType(LoginScreen));

  expect(find.text(l10n.notesAreLocked), findsOneWidget);
  await tester.enterText(find.byType(TextFormField), initialPassword);
  await _tapAndSettle(tester, find.text(l10n.unlock));
  expect(find.text(l10n.wrongPasswordError), findsOneWidget);

  await tester.enterText(find.byType(TextFormField), changedPassword);
  await _tapAndSettle(tester, find.text(l10n.unlock));
  await _pumpUntilFound(tester, find.byType(NotesPage));

  expect(find.text(firstNoteUpdatedTitle), findsOneWidget);
  expect(find.text(secondNoteTitle), findsOneWidget);
}

Future<void> _verifyEverySortingOption(WidgetTester tester, AppLocalizations l10n) async {
  await _setSortingOptionAndExpectOrder(
    tester,
    l10n,
    currentValue: l10n.newestFirst,
    newValue: l10n.aToZ,
    expectedTitles: [firstNoteUpdatedTitle, secondNoteTitle],
  );

  await _setSortingOptionAndExpectOrder(
    tester,
    l10n,
    currentValue: l10n.aToZ,
    newValue: l10n.zToA,
    expectedTitles: [secondNoteTitle, firstNoteUpdatedTitle],
  );

  await _setSortingOptionAndExpectOrder(
    tester,
    l10n,
    currentValue: l10n.zToA,
    newValue: l10n.newestFirst,
    expectedTitles: [secondNoteTitle, firstNoteUpdatedTitle],
  );

  await _setSortingOptionAndExpectOrder(
    tester,
    l10n,
    currentValue: l10n.newestFirst,
    newValue: l10n.oldestFirst,
    expectedTitles: [firstNoteUpdatedTitle, secondNoteTitle],
  );
}

Future<void> _setSortingOptionAndExpectOrder(
  WidgetTester tester,
  AppLocalizations l10n, {
  required String currentValue,
  required String newValue,
  required List<String> expectedTitles,
}) async {
  await _tapAndSettle(tester, find.byIcon(Icons.settings_outlined));
  await _pumpUntilFound(tester, find.byType(SettingsPage));

  await _setDropdownValue(tester, currentValue: currentValue, newValue: newValue);
  expect(find.text(newValue), findsOneWidget);

  await _pageBackAndSettle(tester);
  await _pumpUntilFound(tester, find.byType(NotesPage));
  await _expectVisibleNoteOrder(tester, expectedTitles);
}

Future<void> _expectVisibleNoteOrder(WidgetTester tester, List<String> orderedTitles) async {
  for (final title in orderedTitles) {
    await _pumpUntilFound(tester, find.text(title));
  }

  for (var i = 0; i < orderedTitles.length - 1; i++) {
    final currentY = tester.getTopLeft(find.text(orderedTitles[i])).dy;
    final nextY = tester.getTopLeft(find.text(orderedTitles[i + 1])).dy;
    expect(currentY, lessThan(nextY), reason: '${orderedTitles[i]} should appear before ${orderedTitles[i + 1]}');
  }
}

Future<void> _verifyNoExportSuggestionAfterDisabled(WidgetTester tester, AppLocalizations l10n) async {
  await _tapAndSettle(tester, find.text(firstNoteUpdatedTitle));
  expect(find.text(firstNoteUpdatedContent), findsOneWidget);

  await _tapAndSettle(tester, find.byIcon(Icons.edit_rounded));
  expect(find.text(l10n.editNoteTitle), findsOneWidget);

  await _fillCurrentNoteForm(
    tester,
    title: firstNoteUpdatedTitle,
    content: '$firstNoteUpdatedContent Export suggestions stay disabled.',
  );
  await _tapAndSettle(tester, find.byIcon(Icons.check_rounded));

  expect(find.text(firstNoteUpdatedTitle), findsAtLeast(1));
  expect(find.text(l10n.exportSuggestionSnackbar), findsNothing);

  await _pageBackAndSettle(tester);
  await _pumpUntilFound(tester, find.byType(NotesPage));
  expect(find.text(l10n.exportSuggestionSnackbar), findsNothing);
}
