import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase/usecase.dart';
import 'package:smart_learn/features/user/domain/entities/user_entity.dart';
import 'package:smart_learn/features/user/domain/parameters/user_params.dart';
import 'package:smart_learn/features/user/domain/repositories/user_repository.dart';

class UCEUserUpdate extends UseCase<ENTUser, PARUserUpdate> {
  final REPUser _repository;
  UCEUserUpdate(this._repository);

  @override
  Future<Either<Failure, ENTUser>> call(PARUserUpdate params) async {
    final userUpdated = ENTUser(
      id: params.user.id,
      name: params.name ?? params.user.name,
      age: params.age ?? params.user.age,
      email: params.email ?? params.user.email,
      avatar: params.avatar ?? params.user.avatar,
      bio: params.bio ?? params.user.bio,
      grade: params.grade ?? params.user.grade,
      hobbies: params.hobbies ?? params.user.hobbies,
    );

    final result = await _repository.update(userUpdated);
    return result.fold(
      (failure) => Left(failure),
      (sucsess) => sucsess ? Right(userUpdated) : Left(CacheFailure()),
    );
  }
}