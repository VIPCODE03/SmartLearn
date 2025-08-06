
import 'package:smart_learn/features/assistant/domain/entities/content_entity.dart';

class MessForeignParams {
  final String convertationId;
  MessForeignParams(this.convertationId);
}

class MessAddParams {
  final MessForeignParams foreign;
  final Role role;
  final ENTContent content;
  MessAddParams(this.foreign, {required this.role, required this.content});
}

class MessGetParams {
  final MessForeignParams foreign;
  MessGetParams(this.foreign);
}