import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_learn/core/error/log.dart';

class LocalStorageService {

  static Future<String> saveByte(
      Uint8List bytes,
      {
        String? name,
        String? folderName,
      }) async {
    final baseDir = await getApplicationDocumentsDirectory();

    final dirPath = folderName != null
        ? '${baseDir.path}/$folderName'
        : baseDir.path;

    final dir = Directory(dirPath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final String fileName = name ?? '${DateTime.now().millisecondsSinceEpoch}.file';
    final String filePath = '$dirPath/$fileName';

    final file = File(filePath);
    await file.writeAsBytes(bytes);

    return file.path;
  }


  static Future<String?> pickAndSaveAnyFileToAppDir({String? folderName}) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
      withData: false,
    );

    if (result != null && result.files.single.path != null) {
      final selectedFile = File(result.files.single.path!);

      final baseDir = await getApplicationDocumentsDirectory();
      final dirPath = folderName != null
          ? '${baseDir.path}/$folderName'
          : baseDir.path;

      final dir = Directory(dirPath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final originalName = result.files.single.name;
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final newFileName = '${timestamp}_$originalName';
      final newPath = '$dirPath/$newFileName';

      final savedFile = await selectedFile.copy(newPath);

      logDev('Đã lưu file tại: ${savedFile.path}');
      return savedFile.path;
    }

    return null;
  }

  static Future<bool> deleteFile(String path) async {
    try {
      final file = File(path);

      if (await file.exists()) {
        await file.delete();
        logDev('Đã xóa file tại: $path');
        return true;
      } else {
        logDev('Không tìm thấy file để xóa: $path');
        return false;
      }
    } catch (e) {
      logDev('Lỗi khi xóa file: $e');
      return false;
    }
  }
}