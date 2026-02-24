import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'path_service.g.dart';

class PathService {
  Future<Directory> getTempDirectory() async => await getTemporaryDirectory();
}

@riverpod
PathService pathService(Ref ref) => PathService();
