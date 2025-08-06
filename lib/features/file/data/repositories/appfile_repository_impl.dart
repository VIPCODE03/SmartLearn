
import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/error/log.dart';
import 'package:smart_learn/features/file/data/datasources/appfile_datasource_local.dart';
import 'package:smart_learn/features/file/data/models/appfile_model.dart';
import 'package:smart_learn/features/file/domain/entities/appfile_entity.dart';
import 'package:smart_learn/features/file/domain/parameters/file_params.dart';
import 'package:smart_learn/features/file/domain/repositories/appfile_repository.dart';

class REPAppFileImpl extends REPAppFile {
  final LDSAppFile _local;
  REPAppFileImpl(this._local);

  @override
  Future<Either<Failure, ENTAppFile>> createFile(ENTAppFile file, {required FileForeignParams foreign}) async {
    try {
      final result = await _local.createFile(MODAppFile.fromEntity(file), foreign: foreign);
      return Right(result);
    }
    catch (e, s) {
      logError(e, stackTrace: s, context: 'REPAppFileImpl.createFile failed');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, ENTAppFile>> updateFile(ENTAppFile file) async {
    try {
      final result = await _local.updateFile(MODAppFile.fromEntity(file));
      return Right(result);
    }
    catch (e, s) {
      logError(e, stackTrace: s, context: 'REPAppFileImpl.updateFile failed');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteFile(String id) async {
    try {
      final result = await _local.deleteFile(id);
      return Right(result);
    }
    catch (e, s) {
      logError(e, stackTrace: s, context: 'REPAppFileImpl.deleteFile failed');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteFiles(String pathId) async {
    try {
      final result = await _local.deleteFiles(pathId);
      return Right(result);
    }
    catch (e, s) {
      logError(e, stackTrace: s, context: 'REPAppFileImpl.deleteFiles failed');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, ENTAppFile?>> getFile(String id) async {
    try {
      final result = await _local.getFile(id);
      return Right(result);
    }
    catch (e, s) {
      logError(e, stackTrace: s, context: 'REPAppFileImpl.getFile failed');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ENTAppFile>>> getFiles(String pathId, {required FileForeignParams foreign}) async {
    try {
      final result = await _local.getFiles(pathId, foreign: foreign);
      return Right(result);
    }
    catch (e, s) {
      logError(e, stackTrace: s, context: 'REPAppFileImpl.getFiles failed');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, ENTAppFile?>> getFileByPathName(String pathId, String name, {required FileForeignParams foreign}) async {
    try {
      final result = await _local.getFileByPathName(pathId, name, foreign: foreign);
      return Right(result);
    }
    catch (e, s) {
      logError(e, stackTrace: s, context: 'REPAppFileImpl.getFileByPathName failed');
      return Left(CacheFailure());
    }
  }
}