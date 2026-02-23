import 'package:private_notes_light/features/notes/data/title_warning_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'title_warning_pref.g.dart';

@riverpod
class TitleWarningPref extends _$TitleWarningPref {
  late final TitleWarningRepository _titleWarningRepository;

  @override
  Future<bool> build() async {
    _titleWarningRepository = await ref.read(titleWarningRepositoryProvider.future);
    return _titleWarningRepository.getPref();
  }

  Future<void> dontShowAgain() async {
    await _titleWarningRepository.setPref(false);
    dismiss();
  }

  void dismiss() => state = AsyncValue.data(false);
}
