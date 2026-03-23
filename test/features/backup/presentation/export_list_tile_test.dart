import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:private_notes_light/features/backup/application/export_service.dart';
import 'package:private_notes_light/features/backup/presentation/export_list_tile.dart';
import 'package:private_notes_light/features/settings/presentation/settings_page.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

void main() {
  testWidgets('ExportListTile shows error snackbar if export fails.', (widgetTester) async {
    // Setup
    await widgetTester.pumpWidget(
      ProviderScope(
        overrides: [exportServiceProvider.overrideWith((ref) => throw Exception())],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SettingsPage(),
        ),
      ),
    );
    await widgetTester.pump();
    final context = widgetTester.element(find.byType(ExportListTile));

    // Act
    await widgetTester.tap(find.byKey(const ValueKey('ExportListTile')));
    await widgetTester.pumpAndSettle();

    // Verify
    expect(find.text(AppLocalizations.of(context)!.errorOccurred), findsOne);
  });

  testWidgets('ExportListTile shows success snackbar if export works.', (widgetTester) async {
    // Setup
    await widgetTester.pumpWidget(
      ProviderScope(
        overrides: [exportServiceProvider.overrideWith((ref) => true)],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SettingsPage(),
        ),
      ),
    );
    await widgetTester.pump();
    final context = widgetTester.element(find.byType(ExportListTile));

    // Act
    await widgetTester.tap(find.byKey(const ValueKey('ExportListTile')));
    await widgetTester.pumpAndSettle();

    // Verify
    expect(find.text(AppLocalizations.of(context)!.exportSuccess), findsOne);
  });
}
