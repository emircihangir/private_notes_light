import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:private_notes_light/features/backup/domain/backup_data.dart';

part 'import_controller_state.freezed.dart';

enum ImportErrorKind { fileIsCorrupt, couldNotParseJson, invalidFileType }

@freezed
class ImportControllerState with _$ImportControllerState {
  const factory ImportControllerState.showError({required ImportErrorKind errorKind}) = _ShowError;
  const factory ImportControllerState.showSuccess() = _ShowSuccess;
  const factory ImportControllerState.showPasswordDialog(BackupData backupData) =
      _ShowPasswordDialog;
  const factory ImportControllerState.askForSettings(BackupData backupData) = _AskForSettings;
  const factory ImportControllerState.showOverwriteWarning() = _ShowOverwriteWarning;
}
