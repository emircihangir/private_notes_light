void main() {
  // testWidgets('does not allow empty password input', (widgetTester) async {
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

  //   await widgetTester.tap(find.byKey(const ValueKey('SubmitButton')));
  //   await widgetTester.pumpAndSettle();

  //   // Verify
  //   expect(find.text(AppLocalizations.of(context)!.passwordEmptyError), findsOne);
  // });
}
