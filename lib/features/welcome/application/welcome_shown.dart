import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/welcome/data/welcome_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'welcome_shown.g.dart';

@riverpod
Future<bool> welcomeShown(Ref ref) async {
  return await ref.read(welcomeRepositoryProvider).isShown;
}
