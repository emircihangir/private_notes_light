import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/authentication/application/auth_service.dart';
import 'package:private_notes_light/features/backup/application/file_picker_running.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_expired.g.dart';

@riverpod
class SessionExpired extends _$SessionExpired {
  @override
  bool build() => false;
  void setExpired(bool value) => state = value;
}

class SessionLifecycleObserver extends WidgetsBindingObserver {
  final Ref ref;
  bool logoutOnResume = false;

  SessionLifecycleObserver(this.ref) {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final filePickerRunning = ref.read(filePickerRunningProvider);

    if (state == AppLifecycleState.inactive && !filePickerRunning) {
      log('The app lost focus. Logging out.', name: 'INFO');
      logoutOnResume = true;
      ref.read(authServiceProvider).logout();
    }

    if (state == AppLifecycleState.resumed && logoutOnResume) {
      log('Forcing the user to login again.', name: 'INFO');
      ref.read(sessionExpiredProvider.notifier).setExpired(true);
      logoutOnResume = false;
    }
  }
}

final sessionLifecycleProvider = Provider.autoDispose<SessionLifecycleObserver>((ref) {
  final observer = SessionLifecycleObserver(ref);
  ref.onDispose(() => observer.dispose());
  return observer;
});
