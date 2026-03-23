import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'welcome_repository.g.dart';

class WelcomeRepository {
  static const String sharedPrefKey = 'welcomePageShown';

  Future<void> markShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(sharedPrefKey, true);
  }

  Future<bool> get isShown async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPrefKey) == true;
  }
}

@riverpod
WelcomeRepository welcomeRepository(Ref ref) => WelcomeRepository();
