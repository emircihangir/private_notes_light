import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// Main title greeting on the auth screens.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// Main title on login screen.
  ///
  /// In en, this message translates to:
  /// **'Notes Are Locked'**
  String get notesAreLocked;

  /// Disclaimer text explaining the importance of the master password.
  ///
  /// In en, this message translates to:
  /// **'Please set up a master password. Be careful, there is no way to unlock your notes without the master password.'**
  String get masterPasswordSetupWarning;

  /// Hint text displayed inside the password text field.
  ///
  /// In en, this message translates to:
  /// **'Master password'**
  String get masterPasswordHint;

  /// No description provided for @masterPasswordConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm master password'**
  String get masterPasswordConfirm;

  /// Error snackbar message shown when the user attempts to sign up with an empty password.
  ///
  /// In en, this message translates to:
  /// **'Master password input cannot be empty.'**
  String get masterPasswordEmptyError;

  /// Label for the sign-up submission button.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signupButton;

  /// Generic error snackbar message when the sign-up process fails.
  ///
  /// In en, this message translates to:
  /// **'Signup failed. Please try again.'**
  String get signupGenericError;

  /// Label for the unlock button.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// Error message when password field is empty during login.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password.'**
  String get passwordEmptyError;

  /// Error message for invalid password submission.
  ///
  /// In en, this message translates to:
  /// **'Wrong password.'**
  String get wrongPasswordError;

  /// Snackbar message shown when data export completes successfully.
  ///
  /// In en, this message translates to:
  /// **'Export successful.'**
  String get exportSuccess;

  /// Title for the export option in the settings or list.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportDataTitle;

  /// Subtitle/Description for the export option.
  ///
  /// In en, this message translates to:
  /// **'Save your notes to a local file'**
  String get exportDataSubtitle;

  /// Title displayed on the file picker dialog.
  ///
  /// In en, this message translates to:
  /// **'Select a Backup File'**
  String get importSelectBackupTitle;

  /// Snackbar message shown when data import completes successfully.
  ///
  /// In en, this message translates to:
  /// **'Import successful.'**
  String get importSuccess;

  /// Title for the import option in the settings or list.
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get importDataTitle;

  /// Subtitle/Description for the import option.
  ///
  /// In en, this message translates to:
  /// **'Restore notes from a backup file'**
  String get importDataSubtitle;

  /// Title of the dialog asking to import settings.
  ///
  /// In en, this message translates to:
  /// **'Import settings?'**
  String get importSettingsDialogTitle;

  /// Content warning in the import settings dialog.
  ///
  /// In en, this message translates to:
  /// **'Selecting Yes will overwrite your current settings.'**
  String get importSettingsDialogContent;

  /// Generic negative response button text.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Generic affirmative response button text.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// Generic confirmation dialog title.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// Warning message displayed before importing data over existing data.
  ///
  /// In en, this message translates to:
  /// **'You currently have notes saved in the database. Importing will override or delete existing notes.'**
  String get overwriteWarningContent;

  /// Generic cancel button text.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Generic continue/proceed button text.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get proceed;

  /// Title of the dialog asking to delete a note.
  ///
  /// In en, this message translates to:
  /// **'Delete Note?'**
  String get deleteNoteTitle;

  /// Warning content when deleting a note.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteNoteContent;

  /// Generic delete button text.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Snackbar message shown when the app session expires due to backgrounding.
  ///
  /// In en, this message translates to:
  /// **'The app lost focus. Please login again.'**
  String get sessionExpiredMessage;

  /// Title of the main notes list screen.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesTitle;

  /// Hint text in the search bar.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchHint;

  /// Message displayed when the notes list is empty.
  ///
  /// In en, this message translates to:
  /// **'No notes.'**
  String get noNotesTitle;

  /// Button label to create a note from the empty state.
  ///
  /// In en, this message translates to:
  /// **'Create One'**
  String get createNoteButton;

  /// AppBar title when creating a new note.
  ///
  /// In en, this message translates to:
  /// **'Create Note'**
  String get createNoteTitle;

  /// AppBar title when editing an existing note.
  ///
  /// In en, this message translates to:
  /// **'Edit Note'**
  String get editNoteTitle;

  /// Label and hint text for the note title input field.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get noteTitleLabel;

  /// Label and hint text for the note content input field.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get noteContentLabel;

  /// Validation error when saving a note without a title.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title.'**
  String get titleEmptyError;

  /// Validation error when saving a note without content.
  ///
  /// In en, this message translates to:
  /// **'Please write some content.'**
  String get contentEmptyError;

  /// Generic save button text.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// AppBar title for the settings screen.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Section header for data/storage related settings.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagementSection;

  /// Label for the toggle enabling export suggestions.
  ///
  /// In en, this message translates to:
  /// **'Export Suggestions'**
  String get exportSuggestions;

  /// Label for the toggle enabling export warnings.
  ///
  /// In en, this message translates to:
  /// **'Export Warnings'**
  String get exportWarnings;

  /// Section header for theme/appearance settings.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeSection;

  /// Section header for app information.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSection;

  /// Link title for the source code repository.
  ///
  /// In en, this message translates to:
  /// **'Source Code'**
  String get sourceCodeTitle;

  /// Subtitle describing the source code link.
  ///
  /// In en, this message translates to:
  /// **'Available on GitHub'**
  String get sourceCodeSubtitle;

  /// Link title for reporting feedback.
  ///
  /// In en, this message translates to:
  /// **'Report Feedback'**
  String get reportFeedbackTitle;

  /// Subtitle describing the feedback method.
  ///
  /// In en, this message translates to:
  /// **'Contact via Email'**
  String get reportFeedbackSubtitle;

  /// Link title for donation/support.
  ///
  /// In en, this message translates to:
  /// **'Support Development'**
  String get supportDevelopmentTitle;

  /// Subtitle describing the support method.
  ///
  /// In en, this message translates to:
  /// **'Buy me a coffee'**
  String get supportDevelopmentSubtitle;

  /// The name of the application.
  ///
  /// In en, this message translates to:
  /// **'Private Notes'**
  String get appName;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Developer credit text.
  ///
  /// In en, this message translates to:
  /// **'Developed by Muhammed Emir Cihangir'**
  String get developedBy;

  /// Label for light theme mode.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// Label for system default theme mode.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// Label for dark theme mode.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// Title for the settings list tile responsible for changing the master password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// Subtitle for the settings list tile responsible for changing the master password.
  ///
  /// In en, this message translates to:
  /// **'Update the master password'**
  String get changePasswordSubtitle;

  /// Title for the submit button on the change master password bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submitButton;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @newPasswordConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get newPasswordConfirm;

  /// No description provided for @newPasswordWarning.
  ///
  /// In en, this message translates to:
  /// **'Caution: Do not forget the new password, as there is no way to recover your notes without it.'**
  String get newPasswordWarning;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsDontMatch;

  /// No description provided for @changedPasswordSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password change successful.'**
  String get changedPasswordSuccessfully;

  /// No description provided for @couldNotParseJson.
  ///
  /// In en, this message translates to:
  /// **'Could not parse the selected file. Make sure the file follows JSON syntax.'**
  String get couldNotParseJson;

  /// No description provided for @fileIsCorrupt.
  ///
  /// In en, this message translates to:
  /// **'File is corrupt. Failed to retrieve data.'**
  String get fileIsCorrupt;

  /// No description provided for @importPasswordDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get importPasswordDialogTitle;

  /// No description provided for @importPasswordDialogContent.
  ///
  /// In en, this message translates to:
  /// **'The import file could not be decrypted with the current master key. Please enter a password to decrypt the import file.'**
  String get importPasswordDialogContent;

  /// No description provided for @invalidFileType.
  ///
  /// In en, this message translates to:
  /// **'Invalid file type. Please choose a JSON file.'**
  String get invalidFileType;

  /// No description provided for @noNotesFound.
  ///
  /// In en, this message translates to:
  /// **'No notes found'**
  String get noNotesFound;

  /// No description provided for @exportSuggestionSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Would you like to export?'**
  String get exportSuggestionSnackbar;

  /// No description provided for @failedToDeleteNote.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete note.'**
  String get failedToDeleteNote;

  /// No description provided for @failedToCreateNote.
  ///
  /// In en, this message translates to:
  /// **'Failed to create note.'**
  String get failedToCreateNote;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @exportWarningSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Last export was more than a week ago. Export recommended.'**
  String get exportWarningSnackbar;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @noteDeleted.
  ///
  /// In en, this message translates to:
  /// **'Note deleted.'**
  String get noteDeleted;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @trashedNotes.
  ///
  /// In en, this message translates to:
  /// **'Trashed Notes'**
  String get trashedNotes;

  /// No description provided for @putBack.
  ///
  /// In en, this message translates to:
  /// **'Put Back'**
  String get putBack;

  /// No description provided for @trashedNotesExplainer.
  ///
  /// In en, this message translates to:
  /// **'These are permanently deleted on logout.'**
  String get trashedNotesExplainer;

  /// No description provided for @titleWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning: Note titles are not encrypted. Do not write sensitive information in titles.'**
  String get titleWarning;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @dontShowAgain.
  ///
  /// In en, this message translates to:
  /// **'Don\'t show again'**
  String get dontShowAgain;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'Error occurred.'**
  String get errorOccurred;

  /// No description provided for @failedToExport.
  ///
  /// In en, this message translates to:
  /// **'Export failed.'**
  String get failedToExport;

  /// No description provided for @slide1Content.
  ///
  /// In en, this message translates to:
  /// **'Private Notes keeps your data completely to yourself. Every note you write is encrypted with AES-256 using your master password before it is ever saved to your device. No one else can read your notes, not the developer, not any third party service, and not anyone who might gain access to your device. There are no servers, no cloud sync, and no accounts. Everything stays local, encrypted, and entirely under your control.'**
  String get slide1Content;

  /// No description provided for @slide1Title.
  ///
  /// In en, this message translates to:
  /// **'Your notes, fully private.'**
  String get slide1Title;

  /// No description provided for @slide2Title.
  ///
  /// In en, this message translates to:
  /// **'How to Use'**
  String get slide2Title;

  /// No description provided for @slide2Content.
  ///
  /// In en, this message translates to:
  /// **'When you first open the app, you will be asked to create a master password. This password is the key that encrypts and decrypts all of your notes, so choose something memorable but strong. Once you are logged in, tap the plus button to create a new note. Tap any existing note to view or edit it. To delete a note, open it and use the delete option from the menu. If you want to keep a backup of your notes, head over to the backup section in settings where you can export your encrypted notes to a file and import them again whenever you need.'**
  String get slide2Content;

  /// No description provided for @slide3Content.
  ///
  /// In en, this message translates to:
  /// **'Please read this carefully before you begin. The developer provides this application as is and accepts no responsibility whatsoever for any loss, corruption, theft, or inaccessibility of your notes or any other data stored within the app. This includes but is not limited to data loss caused by forgotten passwords, device failures, accidental deletion, or software bugs. You are solely responsible for keeping your data safe. It is strongly recommended that you export and store a backup of your notes on a regular basis. If you forget your master password, there is no recovery mechanism and your notes will be permanently inaccessible. By proceeding, you acknowledge that you have read this notice and agree to these terms.'**
  String get slide3Content;

  /// No description provided for @slide3Title.
  ///
  /// In en, this message translates to:
  /// **'Important Notice'**
  String get slide3Title;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @documentation.
  ///
  /// In en, this message translates to:
  /// **'Documentation'**
  String get documentation;

  /// No description provided for @documentationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Available on DeepWiki'**
  String get documentationSubtitle;

  /// No description provided for @exportSuggestionsHelpText.
  ///
  /// In en, this message translates to:
  /// **'Shows a backup prompt snackbar on every save.'**
  String get exportSuggestionsHelpText;

  /// No description provided for @exportWarningsHelpText.
  ///
  /// In en, this message translates to:
  /// **'Shows a backup reminder snackbar if last export was over 7 days ago.'**
  String get exportWarningsHelpText;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
