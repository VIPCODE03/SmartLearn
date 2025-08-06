import 'package:equatable/equatable.dart';
import 'package:smart_learn/features/file/domain/entities/appfile_entity.dart';

class AppFileDeleteParams extends Equatable {
  final ENTAppFile file;
  const AppFileDeleteParams({
    required this.file,
  });

  @override
  List<Object?> get props => [file];
}