import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase.dart';
import 'package:smart_learn/features/file/domain/entities/appfile_entity.dart';
import 'package:smart_learn/features/file/domain/parameters/update_params.dart';
import 'package:smart_learn/features/file/domain/repositories/appfile_repository.dart';

class UCEAppFileUpdate extends UseCase<ENTAppFile, AppFileUpdateParams> {
  final REPAppFile repository;
  UCEAppFileUpdate(this.repository);

  @override
  Future<Either<Failure, ENTAppFile>> call(AppFileUpdateParams params) async {
    final ENTAppFile appFileChanged;
    switch(params.currentFile) {
      case ENTAppFileFolder folder:
        appFileChanged = ENTAppFileFolder(
          id: folder.id,
          name: params.name ?? folder.name,
          pathId: params.pathId ?? folder.pathId,
          createAt: folder.createAt,
        );
        break;

      case ENTAppFileTxt txt:
        appFileChanged = ENTAppFileTxt(
          id: txt.id,
          name: params.name ?? txt.name,
          pathId: params.pathId ?? txt.pathId,
          content: params.data ?? txt.content,
          createAt: txt.createAt,
        );
        break;

      case ENTAppFileDraw draw:
        appFileChanged = ENTAppFileDraw(
          id: draw.id,
          name: params.name ?? draw.name,
          pathId: params.pathId ?? draw.pathId,
          json: params.data ?? draw.json,
          createAt: draw.createAt,
        );
        break;

      case ENTAppFileQuiz quiz:
        appFileChanged = ENTAppFileQuiz(
          id: quiz.id,
          name: params.name ?? quiz.name,
          pathId: params.pathId ?? quiz.pathId,
          createAt: quiz.createAt,
        );
        break;

      case ENTAppFileSystem system:
        appFileChanged = ENTAppFileSystem(
          id: system.id,
          name: params.name ?? system.name,
          pathId: params.pathId ?? system.pathId,
          filePath: params.data ?? system.filePath,
          createAt: system.createAt,
        );
        break;

      default:
        return Left(InvalidInputFailure(message: 'Có lỗi gì đó'));
    }

    return repository.updateFile(appFileChanged);
  }
}