void main() {
  // testWidgets('can show overwrite warning.', (widgetTester) async {
  //   // Setup
  //   await widgetTester.pumpWidget(
  //     const ProviderScope(
  //       child: MaterialApp(
  //         localizationsDelegates: AppLocalizations.localizationsDelegates,
  //         supportedLocales: AppLocalizations.supportedLocales,
  //         home: SettingsPage(),
  //       ),
  //     ),
  //   );
  //   await widgetTester.pump();
  //   final context = widgetTester.element(find.byType(ImportListTile));
  //   final container = ProviderScope.containerOf(context);

  //   // Act
  //   container.read(importControllerProvider.notifier).setState(const ImportControllerState.showOverwriteWarning());
  //   await widgetTester.pumpAndSettle();

  //   // Verify
  //   expect(find.byType(OverwriteWarningDialog), findsOne);
  // });

  // testWidgets('can show error snackbars.', (widgetTester) async {
  //   // Setup
  //   await widgetTester.pumpWidget(
  //     const ProviderScope(
  //       child: MaterialApp(
  //         localizationsDelegates: AppLocalizations.localizationsDelegates,
  //         supportedLocales: AppLocalizations.supportedLocales,
  //         home: SettingsPage(),
  //       ),
  //     ),
  //   );
  //   await widgetTester.pump();
  //   final context = widgetTester.element(find.byType(ImportListTile));
  //   final container = ProviderScope.containerOf(context);

  //   for (var errorKind in ImportExceptionKind.values) {
  //     // Act
  //     container.read(importControllerProvider.notifier).setState(ImportControllerState.showError(errorKind: errorKind));
  //     await widgetTester.pumpAndSettle();

  //     // Verify
  //     expect(find.byKey(const ValueKey('ErrorSnackbar')), findsOne);
  //   }
  // });

  // testWidgets('can show success snackbar.', (widgetTester) async {
  //   // Setup
  //   await widgetTester.pumpWidget(
  //     const ProviderScope(
  //       child: MaterialApp(
  //         localizationsDelegates: AppLocalizations.localizationsDelegates,
  //         supportedLocales: AppLocalizations.supportedLocales,
  //         home: NotesPage(),
  //       ),
  //     ),
  //   );
  //   await widgetTester.pump();
  //   final notesPageContext = widgetTester.element(find.byType(NotesPage));

  //   await widgetTester.tap(find.byIcon(Icons.settings_outlined));
  //   await widgetTester.pumpAndSettle();

  //   final context = widgetTester.element(find.byType(SettingsPage));
  //   final container = ProviderScope.containerOf(context);

  //   // Act
  //   container.read(importControllerProvider.notifier).setState(const ImportControllerState.showSuccess());
  //   await widgetTester.pumpAndSettle();

  //   // Verify
  //   expect(find.text(AppLocalizations.of(notesPageContext)!.importSuccess), findsOne);
  // });

  // testWidgets('can show password dialog.', (widgetTester) async {
  //   // Setup
  //   await widgetTester.pumpWidget(
  //     const ProviderScope(
  //       child: MaterialApp(
  //         localizationsDelegates: AppLocalizations.localizationsDelegates,
  //         supportedLocales: AppLocalizations.supportedLocales,
  //         home: SettingsPage(),
  //       ),
  //     ),
  //   );
  //   await widgetTester.pump();
  //   final context = widgetTester.element(find.byType(ImportListTile));
  //   final container = ProviderScope.containerOf(context);

  //   // Act
  //   container
  //       .read(importControllerProvider.notifier)
  //       .setState(ImportControllerState.showPasswordDialog(dummyBackupData()));
  //   await widgetTester.pumpAndSettle();

  //   // Verify
  //   expect(find.byType(ImportPasswordDialog), findsOne);
  // });

  // testWidgets('can show ImportSettingsDialog', (widgetTester) async {
  //   // Setup
  //   await widgetTester.pumpWidget(
  //     const ProviderScope(
  //       child: MaterialApp(
  //         localizationsDelegates: AppLocalizations.localizationsDelegates,
  //         supportedLocales: AppLocalizations.supportedLocales,
  //         home: SettingsPage(),
  //       ),
  //     ),
  //   );
  //   await widgetTester.pump();
  //   final context = widgetTester.element(find.byType(ImportListTile));
  //   final container = ProviderScope.containerOf(context);

  //   // Act
  //   container.read(importControllerProvider.notifier).setState(ImportControllerState.askForSettings(dummyBackupData()));
  //   await widgetTester.pumpAndSettle();

  //   // Verify
  //   expect(find.byType(ImportSettingsDialog), findsOne);
  // });
}
