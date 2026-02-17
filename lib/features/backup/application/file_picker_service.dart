import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'file_picker_service.g.dart';

class FilePickerService {
  Future<FilePickerResult?> pickFiles({String? dialogTitle}) async {
    return await FilePicker.platform.pickFiles(dialogTitle: dialogTitle);
  }

  Future<String?> saveFile({
    required String fileName,
    String? dialogTitle,
    required Uint8List bytes,
  }) async {
    return await FilePicker.platform.saveFile(
      fileName: fileName,
      dialogTitle: dialogTitle,
      bytes: bytes,
    );
  }
}

@riverpod
FilePickerService filePickerService(Ref ref) => FilePickerService();
