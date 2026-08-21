import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'path_service.g.dart';

class PathService {
  Future<Directory> getTempDirectory() async => await getTemporaryDirectory();
}

@Riverpod(keepAlive: true)
PathService pathService(Ref ref) => PathService();
