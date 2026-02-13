// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcome => 'Welcome';

  @override
  String get masterPasswordSetupWarning =>
      'Please set up a master password. Be careful, there is no way to unlock your notes without the master password.';

  @override
  String get masterPasswordHint => 'Master Password';

  @override
  String get masterPasswordEmptyError =>
      'Master password input cannot be empty.';

  @override
  String get signupButton => 'Sign Up';

  @override
  String get signupGenericError => 'Signup failed. Please try again.';

  @override
  String get login => 'Login';

  @override
  String get passwordEmptyError => 'Password input cannot be empty.';

  @override
  String get wrongPasswordError => 'Wrong password. Please try again.';

  @override
  String get exportSuccess => 'Export successful.';

  @override
  String get exportDataTitle => 'Export Data';

  @override
  String get exportDataSubtitle => 'Save your notes to a local file';

  @override
  String get importSelectBackupTitle => 'Select a Backup File';

  @override
  String get importSuccess => 'Import successful.';

  @override
  String get importDataTitle => 'Import Data';

  @override
  String get importDataSubtitle => 'Restore notes from a backup file';

  @override
  String get importSettingsDialogTitle => 'Import settings?';

  @override
  String get importSettingsDialogContent =>
      'Selecting Yes will overwrite your current settings.';

  @override
  String get no => 'No';

  @override
  String get yes => 'Yes';

  @override
  String get areYouSure => 'Are you sure?';

  @override
  String get overwriteWarningContent =>
      'You currently have notes saved in the database. Importing will override or delete existing notes.';

  @override
  String get cancel => 'Cancel';

  @override
  String get proceed => 'Proceed';

  @override
  String get deleteNoteTitle => 'Delete Note?';

  @override
  String get deleteNoteContent => 'This action cannot be undone.';

  @override
  String get delete => 'Delete';

  @override
  String get sessionExpiredMessage => 'The app lost focus. Please login again.';

  @override
  String get notesTitle => 'Notes';

  @override
  String get searchHint => 'Search';

  @override
  String get noNotesTitle => 'No notes.';

  @override
  String get createNoteButton => 'Create One';

  @override
  String get createNoteTitle => 'Create Note';

  @override
  String get editNoteTitle => 'Edit Note';

  @override
  String get noteTitleLabel => 'Title';

  @override
  String get noteContentLabel => 'Content';

  @override
  String get titleEmptyError => 'Title input cannot be empty.';

  @override
  String get contentEmptyError => 'Content input cannot be empty.';

  @override
  String get save => 'Save';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get dataManagementSection => 'Data Management';

  @override
  String get exportSuggestions => 'Export Suggestions';

  @override
  String get exportWarnings => 'Export Warnings';

  @override
  String get themeSection => 'Theme';

  @override
  String get aboutSection => 'About';

  @override
  String get sourceCodeTitle => 'Source Code';

  @override
  String get sourceCodeSubtitle => 'Available on GitHub';

  @override
  String get reportFeedbackTitle => 'Report Feedback';

  @override
  String get reportFeedbackSubtitle => 'Contact via Email';

  @override
  String get supportDevelopmentTitle => 'Support Development';

  @override
  String get supportDevelopmentSubtitle => 'Buy me a coffee';

  @override
  String get appName => 'Private Notes Light';

  @override
  String get appVersionInfo => 'Version 1.0.0 • February 2026';

  @override
  String get developedBy => 'Developed by Muhammed Emir Cihangir';

  @override
  String get themeLight => 'Light';

  @override
  String get themeSystem => 'System';

  @override
  String get themeDark => 'Dark';
}
