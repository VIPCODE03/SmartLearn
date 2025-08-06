import 'package:smart_learn/core/applink/data/models/quizlink_model.dart';
import 'package:smart_learn/core/applink/domain/entities/applink_entity.dart';
import 'package:smart_learn/core/database/tables/table.dart';

mixin MODAppLinkMixin {
  String get id;
  String get tag;
  TableLink get table;

  Map<String, dynamic> toBaseJson() {
    return {
      table.columnLinkId: id,
      table.columnTag: tag,
      'tableName': table.tableName,
    };
  }
}

abstract class MODAppLink extends ENTAppLink {
  const MODAppLink({required super.id, required super.tag});

  Map<String, dynamic> toJson();
  TableLink get table;

  factory MODAppLink.fromJson(Map<String, dynamic> json) {
    final tableName = json['tableName'] as String;
    return switch(tableName) {
      'quizlinktable' => MODQuizLink.fromJson(json),
      _ => throw UnimplementedError(),
    };
  }

  factory MODAppLink.fromEntity(ENTAppLink entity) {
    return switch(entity) {
      MODQuizLink _ => MODQuizLink.fromEntity(entity),
      ENTAppLink _ => throw UnimplementedError(),
    };
  }
}
