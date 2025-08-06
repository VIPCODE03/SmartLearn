import 'package:equatable/equatable.dart';
import 'package:smart_learn/features/file/domain/entities/appfile_entity.dart';

class AppFileUpdateParams extends Equatable {
  final ENTAppFile currentFile;
  final String? name;
  final String? pathId;
  final dynamic data;

  const AppFileUpdateParams.rename(this.currentFile, {required this.name})
      : data = null, pathId = null;

  const AppFileUpdateParams.folder(this.currentFile, {this.name, this.pathId})
      : assert(currentFile is ENTAppFileFolder, 'currentFile must be ENTAppFileFolder'),
        data = null;

  const AppFileUpdateParams.txt(this.currentFile, {this.name, this.pathId, String? content})
      : assert(currentFile is ENTAppFileTxt, 'currentFile must be ENTAppFileTxt'),
        data = content;

  const AppFileUpdateParams.draw(this.currentFile, {this.name, this.pathId, String? json})
      : assert(currentFile is ENTAppFileDraw, 'currentFile must be ENTAppFileDraw'),
        data = json;

  const AppFileUpdateParams.quiz(this.currentFile, {this.name, this.pathId, String? json})
      : assert(currentFile is ENTAppFileQuiz, 'currentFile must be ENTAppFileQuiz'),
        data = json;

  const AppFileUpdateParams.system(this.currentFile, {this.name, this.pathId, String? filePath})
      : assert(currentFile is ENTAppFileSystem, 'currentFile must be ENTAppFileSystem'),
        data = filePath;

  @override
  List<Object?> get props => [name, pathId, data];
}
