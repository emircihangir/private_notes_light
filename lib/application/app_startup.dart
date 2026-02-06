import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/data/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_startup.g.dart';

@riverpod
FutureOr<bool> appStartup(Ref ref) async {
  final authRepository = ref.watch(authRepositoryProvider);
  return await authRepository.userSignedUp;
}
