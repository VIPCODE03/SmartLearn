import 'package:flutter/material.dart';
import 'package:smart_learn/features/file/domain/entities/appfile_entity.dart';

extension AppFileUI on ENTAppFile {
  IconData get iconData => switch (this) {
    ENTAppFileFolder _ => Icons.folder,
    ENTAppFileTxt    _ => Icons.description,
    ENTAppFileDraw   _ => Icons.draw,
    ENTAppFileQuiz  _ => Icons.quiz,
    ENTAppFileFlashCard _ => Icons.style,
    _              => Icons.insert_drive_file,
  };

  Color get iconColor => switch (this) {
    ENTAppFileFolder _ => Colors.amber,
    ENTAppFileTxt    _ => Colors.blue,
    ENTAppFileDraw   _ => Colors.orange,
    ENTAppFileQuiz   _ => Colors.green,
    ENTAppFileFlashCard _ => Colors.brown,
    _              => Colors.grey,
  };
}
