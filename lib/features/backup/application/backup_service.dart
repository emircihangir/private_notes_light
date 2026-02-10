import 'package:private_notes_light/features/backup/data/backup_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'backup_service.g.dart';

@riverpod
class BackupService extends _$BackupService {
  @override
  FutureOr<void> build() {}

  Future<bool?> export() async {
    try {
      final backupRepo = await ref.watch(backupRepositoryProvider.future);
      final result = await backupRepo.export();
      return result;
    } catch (e) {
      return null;
    }
  }

  Future<void> import() async {}
}
