import 'package:equatable/equatable.dart';
import 'package:smart_learn/features/file/domain/parameters/file_params.dart';

class AppFileLoadParams extends Equatable {
  final FileExtenalValue link;
  final String pathId;
  const AppFileLoadParams(this.link, {required this.pathId});

  @override
  List<Object?> get props => [pathId];
}