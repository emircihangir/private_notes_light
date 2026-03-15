import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/authentication/data/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_signed_up.g.dart';

@riverpod
FutureOr<bool> userSignedUp(Ref ref) async {
  final authRepository = ref.watch(authRepositoryProvider);
  return await authRepository.userSignedUp;
}
