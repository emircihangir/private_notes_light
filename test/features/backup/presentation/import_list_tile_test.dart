import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:private_notes_light/features/backup/application/import_controller.dart';
import 'package:private_notes_light/features/backup/domain/import_controller_state.dart';
import 'package:private_notes_light/features/backup/presentation/import_list_tile.dart';
import 'package:private_notes_light/features/backup/presentation/import_password_dialog.dart';
import 'package:private_notes_light/features/backup/presentation/import_settings_dialog.dart';
import 'package:private_notes_light/features/backup/presentation/overwrite_warning_dialog.dart';
import 'package:private_notes_light/features/notes/presentation/notes_page.dart';
import 'package:private_notes_light/features/settings/presentation/settings_page.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

import '../../../core/dummy_backup_data.dart';

void main() {
  testWidgets('can show overwrite warning.', (widgetTester) async {
    // Setup
    await widgetTester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SettingsPage(),
        ),
      ),
    );
    await widgetTester.pump();
    final context = widgetTester.element(find.byType(ImportListTile));
    final container = ProviderScope.containerOf(context);

    // Act
    container
        .read(importControllerProvider.notifier)
        .setState(ImportControllerState.showOverwriteWarning());
    await widgetTester.pumpAndSettle();

    // Verify
    expect(find.byType(OverwriteWarningDialog), findsOne);
  });

  testWidgets('can show error snackbars.', (widgetTester) async {
    // Setup
    await widgetTester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SettingsPage(),
        ),
      ),
    );
    await widgetTester.pump();
    final context = widgetTester.element(find.byType(ImportListTile));
    final container = ProviderScope.containerOf(context);

    for (var errorKind in ImportErrorKind.values) {
      // Act
      container
          .read(importControllerProvider.notifier)
          .setState(ImportControllerState.showError(errorKind: errorKind));
      await widgetTester.pumpAndSettle();

      // Verify
      expect(find.byKey(ValueKey('ErrorSnackbar')), findsOne);
    }
  });

  testWidgets('can show success snackbar.', (widgetTester) async {
    // Setup
    await widgetTester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: NotesPage(),
        ),
      ),
    );
    await widgetTester.pump();
    final notesPageContext = widgetTester.element(find.byType(NotesPage));

    await widgetTester.tap(find.byIcon(Icons.settings_outlined));
    await widgetTester.pumpAndSettle();

    final context = widgetTester.element(find.byType(SettingsPage));
    final container = ProviderScope.containerOf(context);

    // Act
    container.read(importControllerProvider.notifier).setState(ImportControllerState.showSuccess());
    await widgetTester.pumpAndSettle();

    // Verify
    expect(find.text(AppLocalizations.of(notesPageContext)!.importSuccess), findsOne);
  });

  testWidgets('can show password dialog.', (widgetTester) async {
    // Setup
    await widgetTester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SettingsPage(),
        ),
      ),
    );
    await widgetTester.pump();
    final context = widgetTester.element(find.byType(ImportListTile));
    final container = ProviderScope.containerOf(context);

    // Act
    container
        .read(importControllerProvider.notifier)
        .setState(ImportControllerState.showPasswordDialog(dummyBackupData()));
    await widgetTester.pumpAndSettle();

    // Verify
    expect(find.byType(ImportPasswordDialog), findsOne);
  });

  testWidgets('can show ImportSettingsDialog', (widgetTester) async {
    // Setup
    await widgetTester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SettingsPage(),
        ),
      ),
    );
    await widgetTester.pump();
    final context = widgetTester.element(find.byType(ImportListTile));
    final container = ProviderScope.containerOf(context);

    // Act
    container
        .read(importControllerProvider.notifier)
        .setState(ImportControllerState.askForSettings(dummyBackupData()));
    await widgetTester.pumpAndSettle();

    // Verify
    expect(find.byType(ImportSettingsDialog), findsOne);
  });
}
