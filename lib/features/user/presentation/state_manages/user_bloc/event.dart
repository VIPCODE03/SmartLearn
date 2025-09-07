
import 'package:smart_learn/features/user/domain/parameters/user_params.dart';

abstract class UserEvent {}

class UserEventAdd extends UserEvent {
  final PARUserAdd params;
  UserEventAdd(this.params);
}

class UserEventUpdate extends UserEvent {
  final PARUserUpdate params;
  UserEventUpdate(this.params);
}

class UserEventGet extends UserEvent {
  final PARUserGet params;
  UserEventGet(this.params);
}