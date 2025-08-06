import 'package:smart_learn/core/database/tables/file_table.dart';
import 'package:smart_learn/features/file/domain/entities/appfile_entity.dart';

FileTable get _table => FileTable.instance;

mixin MODAppFileMixin {
  String get type;
  String get id;
  String get name;
  String get pathId;
  DateTime get createAt;

  Map<String, dynamic> toJsonBase() {
    return {
      _table.columnType: type,
      _table.columnId: id,
      _table.columnName: name,
      _table.columnPathId: pathId,
      _table.columnCreated: createAt.toIso8601String(),
    };
  }
}

abstract class MODAppFile extends ENTAppFile {
  const MODAppFile({
    required super.id,
    required super.name,
    required super.pathId,
    required super.createAt,
  });

  String get type;

  Map<String, dynamic> toJson();

  factory MODAppFile.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'folder': return MODAppFileFolder.fromJson(json);
      case 'txt': return MODAppFileTxt.fromJson(json);
      case 'draw': return MODAppFileDraw.fromJson(json);
      case 'quiz':  return MODAppFileQuiz.fromJson(json);
      case 'system': return MODAppFileSystem.fromJson(json);
      default: throw Exception('Unknown AppFile type: ${json['type']}');
    }
  }

  factory MODAppFile.fromEntity(ENTAppFile entity) {
    switch (entity) {
      case ENTAppFileFolder _: return MODAppFileFolder.fromEntity(entity);
      case ENTAppFileTxt _: return MODAppFileTxt.fromEntity(entity);
      case ENTAppFileDraw _: return MODAppFileDraw.fromEntity(entity);
      case ENTAppFileQuiz _: return MODAppFileQuiz.fromEntity(entity);
      case ENTAppFileSystem _: return MODAppFileSystem.fromEntity(entity);
      default: throw Exception('Unknown AppFile type: ${entity.runtimeType}');
    }
  }
}

class MODAppFileFolder extends ENTAppFileFolder with MODAppFileMixin implements MODAppFile {
  const MODAppFileFolder({
    required super.id,
    required super.name,
    required super.pathId,
    required super.createAt,
  });

  @override
  String get type => 'folder';

  @override
  Map<String, dynamic> toJson() {
    return {
      ...toJsonBase()
    };
  }

  factory MODAppFileFolder.fromJson(Map<String, dynamic> json) {
    return MODAppFileFolder(
      id: json[_table.columnId],
      name: json[_table.columnName],
      pathId: json[_table.columnPathId],
      createAt: DateTime.parse(json[_table.columnCreated]),
    );
  }

  factory MODAppFileFolder.fromEntity(ENTAppFileFolder entity) {
    return MODAppFileFolder(
      id: entity.id,
      name: entity.name,
      pathId: entity.pathId,
      createAt: entity.createAt,
    );
  }
}

class MODAppFileTxt extends ENTAppFileTxt with MODAppFileMixin implements MODAppFile {
  const MODAppFileTxt({
    required super.id,
    required super.name,
    required super.pathId,
    required super.createAt,
    required super.content,
  });

  @override
  String get type => 'txt';

  @override
  Map<String, dynamic> toJson() {
    return {
      ...toJsonBase(),
      'content': content
    };
  }

  factory MODAppFileTxt.fromJson(Map<String, dynamic> json) {
    return MODAppFileTxt(
        id: json[_table.columnId],
        name: json[_table.columnName],
        pathId: json[_table.columnPathId],
        createAt: DateTime.parse(json[_table.columnCreated]),
        content: json[_table.columnContent],
    );
  }

  factory MODAppFileTxt.fromEntity(ENTAppFileTxt entity) {
    return MODAppFileTxt(
      id: entity.id,
      name: entity.name,
      pathId: entity.pathId,
      createAt: entity.createAt,
      content: entity.content
    );
  }
}

class MODAppFileDraw extends ENTAppFileDraw with MODAppFileMixin implements MODAppFile {
  const MODAppFileDraw({
    required super.id,
    required super.name,
    required super.pathId,
    required super.createAt,
    required super.json
  });

  @override
  String get type => 'draw';

  @override
  Map<String, dynamic> toJson() {
    return {
      ...toJsonBase(),
      'json': json
    };
  }

  factory MODAppFileDraw.fromJson(Map<String, dynamic> json) {
    return MODAppFileDraw(
        id: json[_table.columnId],
        name: json[_table.columnName],
        pathId: json[_table.columnPathId],
        createAt: DateTime.parse(json[_table.columnCreated]),
        json: json[_table.columnJson]
    );
  }

  factory MODAppFileDraw.fromEntity(ENTAppFileDraw entity) {
    return MODAppFileDraw(
        id: entity.id,
        name: entity.name,
        pathId: entity.pathId,
        createAt: entity.createAt,
        json: entity.json
    );
  }
}

class MODAppFileQuiz extends ENTAppFileQuiz with MODAppFileMixin implements MODAppFile {
  const MODAppFileQuiz({
    required super.id,
    required super.name,
    required super.pathId,
    required super.createAt,
  });

  @override
  String get type => 'quiz';

  @override
  Map<String, dynamic> toJson() {
    return {
      ...toJsonBase(),
    };
  }

  factory MODAppFileQuiz.fromJson(Map<String, dynamic> json) {
    return MODAppFileQuiz(
        id: json[_table.columnId],
        name: json[_table.columnName],
        pathId: json[_table.columnPathId],
        createAt: DateTime.parse(json[_table.columnCreated]),
    );
  }

  factory MODAppFileQuiz.fromEntity(ENTAppFileQuiz entity) {
    return MODAppFileQuiz(
        id: entity.id,
        name: entity.name,
        pathId: entity.pathId,
        createAt: entity.createAt,
    );
  }
}

class MODAppFileSystem extends ENTAppFileSystem with MODAppFileMixin implements MODAppFile {
  const MODAppFileSystem({
    required super.id,
    required super.name,
    required super.pathId,
    required super.createAt,
    required super.filePath
  });

  @override
  String get type => 'system';

  @override
  Map<String, dynamic> toJson() {
    return {
      ...toJsonBase(),
      'filePath': filePath
    };
  }

  factory MODAppFileSystem.fromJson(Map<String, dynamic> json) {
    return MODAppFileSystem(
        id: json[_table.columnId],
        name: json[_table.columnName],
        pathId: json[_table.columnPathId],
        createAt: DateTime.parse(json[_table.columnCreated]),
        filePath: json[_table.columnFilePath]
    );
  }

  factory MODAppFileSystem.fromEntity(ENTAppFileSystem entity) {
    return MODAppFileSystem(
        id: entity.id,
        name: entity.name,
        pathId: entity.pathId,
        createAt: entity.createAt,
        filePath: entity.filePath
    );
  }
}
