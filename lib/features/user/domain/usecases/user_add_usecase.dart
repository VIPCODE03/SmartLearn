import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase/usecase.dart';
import 'package:smart_learn/features/user/domain/entities/user_entity.dart';
import 'package:smart_learn/features/user/domain/parameters/user_params.dart';
import 'package:smart_learn/features/user/domain/repositories/user_repository.dart';
import 'package:smart_learn/utils/generate_id_util.dart';

class UCEUserAdd extends UseCase<ENTUser, PARUserAdd> {
  final REPUser _repository;
  UCEUserAdd(this._repository);

  @override
  Future<Either<Failure, ENTUser>> call(PARUserAdd params) async {
    final newUser = ENTUser(
      id: UTIGenerateID.random(),
      name: params.name,
      age: params.age,

      email: params.email,
      avatar: params.avatar,
      bio: params.bio,

      grade: params.grade,
      hobbies: params.hobbies,
    );

    final result = await _repository.add(newUser);
    return result.fold(
      (failure) => Left(failure),
      (sucsess) => sucsess ? Right(newUser) : Left(CacheFailure()),
    );
  }
}