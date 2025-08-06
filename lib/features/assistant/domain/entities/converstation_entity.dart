import 'package:equatable/equatable.dart';

class ENTConversation extends Equatable {
  final String id;
  final String title;
  final DateTime updateLast;

  const ENTConversation({
    required this.id,
    required this.title,
    required this.updateLast,
  });

  factory ENTConversation.empty() => ENTConversation(id: '', title: '', updateLast: DateTime.now());

  @override
  List<Object?> get props => [id, title, updateLast];
}