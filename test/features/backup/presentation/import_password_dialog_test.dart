import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:private_notes_light/features/backup/application/import_controller.dart';
import 'package:private_notes_light/features/backup/domain/import_controller_state.dart';
import 'package:private_notes_light/features/backup/presentation/import_list_tile.dart';
import 'package:private_notes_light/features/settings/presentation/settings_page.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

import '../../../core/dummy_backup_data.dart';

void main() {
  testWidgets('does not allow empty password input', (widgetTester) async {
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

    await widgetTester.tap(find.byKey(ValueKey('SubmitButton')));
    await widgetTester.pumpAndSettle();

    // Verify
    expect(find.text(AppLocalizations.of(context)!.passwordEmptyError), findsOne);
  });
}
