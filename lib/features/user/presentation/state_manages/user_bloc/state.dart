
import 'package:smart_learn/features/user/domain/entities/user_entity.dart';

abstract class UserState {}

abstract class UserNoData extends UserState {}

class UserInit extends UserNoData {}

class UserLoading extends UserNoData {}

class UserError extends UserNoData {}

abstract class UserHasData extends UserState {
  final ENTUser user;
  UserHasData(this.user);
}

class UserLoaded extends UserHasData {
  UserLoaded(super.user);
}

class UserUpdating extends UserHasData {
  UserUpdating(super.user);
}

class UserErrorUpdate extends UserHasData {
  UserErrorUpdate(super.user);
}