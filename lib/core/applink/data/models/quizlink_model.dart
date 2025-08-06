import 'package:smart_learn/core/applink/data/models/applink_model.dart';
import 'package:smart_learn/core/applink/domain/entities/quizlink_entity.dart';
import 'package:smart_learn/core/database/tables/quiz_table.dart';
import 'package:smart_learn/core/database/tables/table.dart';

class MODQuizLink extends ENTQuizLink with MODAppLinkMixin implements MODAppLink {
  const MODQuizLink({required super.id, required super.tag});

  @override
  TableLink get table => QuizLinkTable.instance;

  @override
  Map<String, dynamic> toJson() => toBaseJson();

  factory MODQuizLink.fromJson(Map<String, dynamic> json) {
    final table = QuizLinkTable.instance;
    return MODQuizLink(
      id: json[table.columnLinkId] as String,
      tag: json[table.columnTag] as String,
    );
  }

  factory MODQuizLink.fromEntity(ENTQuizLink entity) {
    return MODQuizLink(id: entity.id, tag: entity.tag);
  }
}