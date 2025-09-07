import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase.dart';
import 'package:smart_learn/features/file/domain/entities/appfile_entity.dart';
import 'package:smart_learn/features/file/domain/parameters/create_params.dart';
import 'package:smart_learn/features/file/domain/repositories/appfile_repository.dart';
import 'package:smart_learn/utils/generate_id_util.dart';

class UCEAppFileCreate extends UseCase<ENTAppFile, AppFileCreateParams> {
  final REPAppFile repository;
  UCEAppFileCreate(this.repository);

  @override
  Future<Either<Failure, ENTAppFile>> call(AppFileCreateParams params) async {
    final String id = UTIGenerateID.random();
    final String name = params.name;
    final String pathId = params.pathId;
    final DateTime createAt = DateTime.now();

    final newFile = switch(params.type) {
      TypeFile.folder => ENTAppFileFolder(id: id, name: name, pathId: pathId, createAt: createAt),
      TypeFile.txt => ENTAppFileTxt(id: id, name: name, pathId: pathId, content: params.data, createAt: createAt),
      TypeFile.draw => ENTAppFileDraw(id: id, name: name, pathId: pathId, json: params.data, createAt: createAt),
      TypeFile.quiz => ENTAppFileQuiz(id: id, name: name, pathId: pathId, createAt: createAt),
      TypeFile.system => ENTAppFileSystem(id: id, name: name, pathId: pathId, filePath: params.data, createAt: createAt),
      TypeFile.flashcard => ENTAppFileFlashCard(id: id, name: name, pathId: pathId, createAt: createAt),
    };

    return repository.createFile(newFile, foreign: params.link);
  }
}