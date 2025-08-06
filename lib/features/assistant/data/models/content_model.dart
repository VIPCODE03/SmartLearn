import 'dart:convert';
import 'package:smart_learn/core/database/tables/assistant_table.dart';
import 'package:smart_learn/features/assistant/domain/entities/content_entity.dart';
import 'package:zent_gemini/gemini_models.dart';

AssistantMessageTable get _table => AssistantMessageTable.instance;

class MODMessage extends ENTMessage {
  MODMessage(super.id, super.role, super.content, {super.createdAt});

  factory MODMessage.fromEntity(ENTMessage entity) 
  => MODMessage(entity.id, entity.role, entity.content);

  Map<String, dynamic> toMap() {
    return {
      _table.columnId: id,
      _table.columnRole: role.toString(),
      _table.columnContent: jsonEncode(MODContent.fromEntity(content).toMap()),
      _table.columnCreatedAt: createdAt.toIso8601String(),
    };
  }

  factory MODMessage.fromMap(Map<String, dynamic> map) {
    Role roleValue = Role.values.firstWhere(
          (e) => e.toString() == map[_table.columnRole],
      orElse: () => Role.user,
    );
    return MODMessage(
        map[_table.columnId],
        roleValue,
        MODContent.fromMap(jsonDecode(map[_table.columnContent])),
        createdAt: DateTime.parse(map[_table.columnCreatedAt])
    );
  }


}

mixin MODContentMixin {
  String get type;
  Content? get content;
  
  Map<String, dynamic> toBaseMap() => {
    'type': type,
    'content': jsonEncode(content?.toJson())
  };
}

abstract class MODContent extends ENTContent {
  MODContent(super.content);

  String get type;

  Map<String, dynamic> toMap();

  factory MODContent.fromMap(Map<String, dynamic> map) {
    switch (map['type']) {
      case 'MODContentText':
        return MODContentText.fromMap(map);
      case 'MODContentImage':
        return MODContentImage.fromMap(map);
      case 'MODContentQuiz':
        return MODContentQuiz.fromMap(map);
      default:
        throw Exception('Unknown content type: ${map['type']}');
    }
  }

  factory MODContent.fromEntity(ENTContent entity) {
    switch (entity) {
      case ENTContentText _:
        return MODContentText.fromEntity(entity);
      case ENTContentImage _:
        return MODContentImage.fromEntity(entity);

      case ENTContentQuiz _:
        return MODContentQuiz.fromEntity(entity);

      default:
        throw Exception('Unknown content type: ${entity.runtimeType}');
    }
  }
}

class MODContentText extends ENTContentText with MODContentMixin implements MODContent {
  MODContentText(super.content);

  @override
  Map<String, dynamic> toMap() => toBaseMap();

  factory MODContentText.fromMap(Map<String, dynamic> map) {
    return MODContentText(Content.fromJson(jsonDecode(map['content'])));
  }

  factory MODContentText.fromEntity(ENTContentText entity) {
    return MODContentText(entity.content);
  }

  @override
  String get type => "MODContentText";
}

class MODContentImage extends ENTContentImage with MODContentMixin implements MODContent {
  MODContentImage(super.content, {super.id});

  @override
  Map<String, dynamic> toMap() => {
    ...toBaseMap(),
    'id': id
  };

  factory MODContentImage.fromMap(Map<String, dynamic> map) {
    return MODContentImage(Content.fromJson(
        jsonDecode(map['content'])),
        id: map['id']
    );
  }

  factory MODContentImage.fromEntity(ENTContentImage entity) {
    return MODContentImage(entity.content, id: entity.id);
  }

  @override
  String get type => "MODContentImage";
}

class MODContentQuiz extends ENTContentQuiz with MODContentMixin implements MODContent {
  MODContentQuiz(super.title, super.content);

  @override
  Map<String, dynamic> toMap() => {
    ...toBaseMap(),
    'title': title
  };

  factory MODContentQuiz.fromMap(Map<String, dynamic> map) {
    return MODContentQuiz(
        map['title'],
        Content.fromJson(jsonDecode(map['content']))
    );
  }

  factory MODContentQuiz.fromEntity(ENTContentQuiz entity) {
    return MODContentQuiz(entity.title, entity.content);
  }

  @override
  String get type => "MODContentQuiz";
}