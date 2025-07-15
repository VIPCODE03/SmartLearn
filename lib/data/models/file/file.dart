
abstract class AppFile {
  final String id;
  String name;
  String? pathId;
  final DateTime dateCreated;

  AppFile({
    required this.id,
    required this.name,
    required this.pathId,
    required this.dateCreated,
  });

  Map<String, dynamic> toJson();

  static AppFile fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'folder':
        return AppFileFolder.fromJson(json);
      case 'txt':
        return AppFileTxt.fromJson(json);
      case 'draw':
        return AppFileDraw.fromJson(json);
      case 'quizz':
        return AppFileQuiz.fromJson(json);
      case 'system':
        return AppFileSystem.fromJson(json);
      default:
        throw Exception('Unknown AppFile type: ${json['type']}');
    }
  }
}

class AppFileFolder extends AppFile {
  AppFileFolder({required super.id, required super.name, required super.pathId, required super.dateCreated, });

  @override
  Map<String, dynamic> toJson() => {
    'type': 'folder',
    'id': id,
    'name': name,
    'pathId': pathId,
    'dateCreated': dateCreated.toIso8601String(),
  };

  factory AppFileFolder.fromJson(Map<String, dynamic> json) => AppFileFolder(
    id: json['id'],
    name: json['name'],
    pathId: json['pathId'],
    dateCreated: DateTime.parse(json['dateCreated'] as String),
  );
}

class AppFileTxt extends AppFile {
  String content;

  AppFileTxt({required super.id, required super.name, required super.pathId, required this.content, required super.dateCreated});

  @override
  Map<String, dynamic> toJson() => {
    'type': 'txt',
    'id': id,
    'name': name,
    'pathId': pathId,
    'content': content,
    'dateCreated': dateCreated.toIso8601String(),
  };

  factory AppFileTxt.fromJson(Map<String, dynamic> json) => AppFileTxt(
    id: json['id'],
    name: json['name'],
    pathId: json['pathId'],
    content: json['content'],
    dateCreated: DateTime.parse(json['dateCreated'] as String),
  );
}

class AppFileDraw extends AppFile {
  String json;

  AppFileDraw({required super.id, required super.name, required super.pathId, required this.json, required super.dateCreated});

  @override
  Map<String, dynamic> toJson() => {
    'type': 'draw',
    'id': id,
    'name': name,
    'pathId': pathId,
    'json': json,
    'dateCreated': dateCreated.toIso8601String(),
  };

  factory AppFileDraw.fromJson(Map<String, dynamic> json) => AppFileDraw(
    id: json['id'],
    name: json['name'],
    pathId: json['pathId'],
    json: json['json'],
    dateCreated: DateTime.parse(json['dateCreated'] as String),
  );
}

class AppFileQuiz extends AppFile {
  String? json;

  AppFileQuiz({required super.id, required super.name, required super.pathId, this.json, required super.dateCreated});

  @override
  Map<String, dynamic> toJson() => {
    'type': 'quizz',
    'id': id,
    'name': name,
    'pathId': pathId,
    'json': json,
    'dateCreated': dateCreated.toIso8601String(),
  };

  factory AppFileQuiz.fromJson(Map<String, dynamic> json) => AppFileQuiz(
    id: json['id'],
    name: json['name'],
    pathId: json['pathId'],
    json: json['json'],
    dateCreated: DateTime.parse(json['dateCreated'] as String),
  );
}

class AppFileSystem extends AppFile {
  String filePath;

  AppFileSystem({required super.id, required super.name, required super.pathId, required this.filePath, required super.dateCreated});

  @override
  Map<String, dynamic> toJson() => {
    'type': 'system',
    'id': id,
    'name': name,
    'pathId': pathId,
    'filePath': filePath,
    'dateCreated': dateCreated.toIso8601String(),
  };

  factory AppFileSystem.fromJson(Map<String, dynamic> json) => AppFileSystem(
    id: json['id'],
    name: json['name'],
    pathId: json['pathId'],
    filePath: json['filePath'],
    dateCreated: DateTime.parse(json['dateCreated'] as String),
  );
}