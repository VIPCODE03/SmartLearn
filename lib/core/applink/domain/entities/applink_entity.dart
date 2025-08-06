import 'package:equatable/equatable.dart';

abstract class ENTAppLink extends Equatable {
  final String id;
  final String tag;
  const ENTAppLink({required this.id, required this.tag});

  @override
  List<Object?> get props => [id, tag];
}