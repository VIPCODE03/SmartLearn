
import 'package:equatable/equatable.dart';

abstract class ENTAppFile extends Equatable {
  final String id;
  final String name;
  final String pathId;
  final DateTime createAt;

  const ENTAppFile({
    required this.id,
    required this.name,
    required this.pathId,
    required this.createAt
  });

  @override
  List<Object?> get props => [id, name];
}

class ENTAppFileFolder extends ENTAppFile {
  const ENTAppFileFolder({
    required super.id,
    required super.name,
    required super.pathId,
    required super.createAt,
  });
}

class ENTAppFileTxt extends ENTAppFile {
  final String? content;
  const ENTAppFileTxt({
    required super.id,
    required super.name,
    required super.pathId,
    required super.createAt,
    required this.content,
  });
}

class ENTAppFileDraw extends ENTAppFile {
  final String? json;
  const ENTAppFileDraw({
    required super.id,
    required super.name,
    required super.pathId,
    required super.createAt,
    required this.json,
  });
}

class ENTAppFileQuiz extends ENTAppFile {
  const ENTAppFileQuiz({
    required super.id,
    required super.name,
    required super.pathId,
    required super.createAt,
  });
}

class ENTAppFileSystem extends ENTAppFile {
  final String filePath;
  const ENTAppFileSystem({
    required super.id,
    required super.name,
    required super.pathId,
    required super.createAt,
    required this.filePath,
  });
}