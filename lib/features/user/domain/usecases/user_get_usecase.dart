import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase/usecase.dart';
import 'package:smart_learn/features/user/domain/entities/user_entity.dart';
import 'package:smart_learn/features/user/domain/parameters/user_params.dart';
import 'package:smart_learn/features/user/domain/repositories/user_repository.dart';

class UCEUserGet extends UseCase<ENTUser, PARUserGet> {
  final REPUser _repository;
  UCEUserGet(this._repository);

  @override
  Future<Either<Failure, ENTUser>> call(PARUserGet params) async {
    return await _repository.get();
  }
}