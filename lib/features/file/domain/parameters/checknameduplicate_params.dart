import 'package:equatable/equatable.dart';
import 'package:smart_learn/features/file/domain/parameters/file_params.dart';

class AppFileCheckDuplicateParams extends Equatable {
  final String newName;
  final String pathId;
  final FileExtenalValue foreign;

  const AppFileCheckDuplicateParams(this.foreign, {
    required this.pathId,
    required this.newName,
  });

  @override
  List<Object?> get props => [pathId, newName];
}