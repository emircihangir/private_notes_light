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
  String get notesAreLocked => 'Notes Are Locked';

  @override
  String get masterPasswordSetupWarning =>
      'Please set up a master password. Be careful, there is no way to unlock your notes without the master password.';

  @override
  String get masterPasswordHint => 'Master password';

  @override
  String get masterPasswordConfirm => 'Confirm master password';

  @override
  String get masterPasswordEmptyError =>
      'Master password input cannot be empty.';

  @override
  String get signupButton => 'Sign Up';

  @override
  String get signupGenericError => 'Signup failed. Please try again.';

  @override
  String get unlock => 'Unlock';

  @override
  String get passwordEmptyError => 'Please enter a password.';

  @override
  String get wrongPasswordError => 'Wrong password.';

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
  String get titleEmptyError => 'Please enter a title.';

  @override
  String get contentEmptyError => 'Please write some content.';

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
  String get appName => 'Private Notes';

  @override
  String get version => 'Version';

  @override
  String get developedBy => 'Developed by Muhammed Emir Cihangir';

  @override
  String get themeLight => 'Light';

  @override
  String get themeSystem => 'System';

  @override
  String get themeDark => 'Dark';

  @override
  String get changePassword => 'Change Password';

  @override
  String get changePasswordSubtitle => 'Update the master password';

  @override
  String get submitButton => 'Submit';

  @override
  String get newPassword => 'New password';

  @override
  String get newPasswordConfirm => 'Confirm new password';

  @override
  String get newPasswordWarning =>
      'Warning: Do not forget the new password, as there is no way to recover your notes without it.';

  @override
  String get passwordsDontMatch => 'Passwords do not match.';

  @override
  String get changedPasswordSuccessfully => 'Password change successful.';

  @override
  String get couldNotParseJson =>
      'Could not parse the selected file. Make sure the file follows JSON syntax.';

  @override
  String get fileIsCorrupt => 'File is corrupt. Failed to retrieve data.';

  @override
  String get importPasswordDialogTitle => 'Enter Password';

  @override
  String get importPasswordDialogContent =>
      'The import file could not be decrypted with the current master key. Please enter a password to decrypt the import file.';

  @override
  String get invalidFileType => 'Invalid file type. Please choose a JSON file.';

  @override
  String get noNotesFound => 'No notes found';

  @override
  String get exportSuggestionSnackbar => 'Would you like to export?';

  @override
  String get failedToDeleteNote => 'Failed to delete note.';

  @override
  String get failedToCreateNote => 'Failed to create note.';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get exportWarningSnackbar =>
      'Last export was more than a week ago. Export recommended.';

  @override
  String get export => 'Export';

  @override
  String get noteDeleted => 'Note deleted.';

  @override
  String get undo => 'Undo';

  @override
  String get trashedNotes => 'Trashed Notes';

  @override
  String get putBack => 'Put Back';

  @override
  String get trashedNotesExplainer =>
      'These are permanently deleted on logout.';

  @override
  String get titleWarning =>
      'Warning: Note titles are not encrypted. Do not write sensitive information in titles.';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get dontShowAgain => 'Don\'t show again';

  @override
  String get errorOccurred => 'Error occurred.';

  @override
  String get failedToExport => 'Export failed.';

  @override
  String get slide1Content =>
      'Private Notes keeps your data completely to yourself. Every note you write is encrypted with AES-256 using your master password before it is ever saved to your device. No one else can read your notes, not the developer, not any third-party service, and not anyone who might gain access to your device. There are no servers, no cloud sync, and no accounts. Everything stays local, encrypted, and entirely under your control.';

  @override
  String get slide1Title => 'Your notes, fully private.';

  @override
  String get slide2Title => 'How to Use';

  @override
  String get slide2Content =>
      'When you first open the app, you will be asked to create a master password. This password is the key that encrypts and decrypts all of your notes, so choose something memorable but strong. Once you are logged in, tap the plus button to create a new note. Tap any existing note to view or edit it. To delete a note, open it and use the delete option from the menu. If you want to keep a backup of your notes, head over to the backup section in settings where you can export your encrypted notes to a file and import them again whenever you need to.';

  @override
  String get slide3Content =>
      'Please read this carefully before you begin. The developer provides this application as is and accepts no responsibility whatsoever for any loss, corruption, theft, or inaccessibility of your notes or any other data stored within the app. This includes, but is not limited to, data loss caused by forgotten passwords, device failures, accidental deletion, or software bugs. You are solely responsible for keeping your data safe. It is strongly recommended that you export and store a backup of your notes on a regular basis. If you forget your master password, there is no recovery mechanism and your notes will be permanently inaccessible. By proceeding, you acknowledge that you have read this notice and agree to these terms.';

  @override
  String get slide3Title => 'Important Notice';

  @override
  String get getStarted => 'Get Started';

  @override
  String get next => 'Next';

  @override
  String get documentation => 'Documentation';

  @override
  String get documentationSubtitle => 'Available on DeepWiki';

  @override
  String get exportSuggestionsHelpText =>
      'Shows a backup prompt snackbar on every save.';

  @override
  String get exportWarningsHelpText =>
      'Shows a backup reminder snackbar if last export was over 7 days ago.';

  @override
  String get ok => 'OK';
}
