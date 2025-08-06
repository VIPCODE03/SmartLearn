import 'package:flutter/material.dart';
import 'package:smart_learn/features/file/presentation/screens/appfile_screen.dart';

abstract class IFileWidget {
  Widget fileView({required String subjectId, required String pathRoot, required List<String> supportTypes});
}

abstract class IFileRouter {}

class _FileWidget implements IFileWidget {
  static final _FileWidget _singleton = _FileWidget._internal();
  _FileWidget._internal();
  static _FileWidget get instance => _singleton;

  @override
  Widget fileView({required String subjectId, required String pathRoot, required List<String> supportTypes})
  => SCRAppFile(
    subjectId: subjectId,
    pathRoot: pathRoot,
    supportTypes: supportTypes.map((e) => _mapToSupportType(e)).toList(),
  );

  SupportType _mapToSupportType(String e) {
    switch (e) {
      case 'folder':
        return SupportType.folder;
      case 'txt':
        return SupportType.txt;
      case 'draw':
        return SupportType.draw;
      case 'quiz':
        return SupportType.quiz;
      case 'system':
        return SupportType.system;
      default:
        throw Exception("Unsupported type: $e");
    }
  }
}

class _FileRouter implements IFileRouter {
  static final _FileRouter _singleton = _FileRouter._internal();
  _FileRouter._internal();
  static _FileRouter get instance => _singleton;
}

class FileProvider {
  static final FileProvider _singleton = FileProvider._internal();
  FileProvider._internal();
  static FileProvider get instance => _singleton;

  IFileWidget get widget => _FileWidget.instance;
  IFileRouter get router => _FileRouter.instance;
}
