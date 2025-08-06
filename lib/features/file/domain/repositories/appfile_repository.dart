
import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/features/file/domain/entities/appfile_entity.dart';
import 'package:smart_learn/features/file/domain/parameters/file_params.dart';

abstract class REPAppFile {
  Future<Either<Failure, ENTAppFile>> createFile(ENTAppFile file, {required FileForeignParams foreign});
  Future<Either<Failure, ENTAppFile>> updateFile(ENTAppFile file);
  Future<Either<Failure, bool>> deleteFile(String id);
  Future<Either<Failure, bool>> deleteFiles(String pathId);

  Future<Either<Failure, List<ENTAppFile>>> getFiles(String pathId, {required FileForeignParams foreign});
  Future<Either<Failure, ENTAppFile?>> getFile(String id);

  Future<Either<Failure, ENTAppFile?>> getFileByPathName(String pathId, String name, {required FileForeignParams foreign});
}