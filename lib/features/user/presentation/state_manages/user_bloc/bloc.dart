
import 'package:bloc/bloc.dart';
import 'package:smart_learn/features/user/domain/entities/user_entity.dart';
import 'package:smart_learn/features/user/domain/usecases/user_add_usecase.dart';
import 'package:smart_learn/features/user/domain/usecases/user_get_usecase.dart';
import 'package:smart_learn/features/user/domain/usecases/user_update_usecase.dart';
import 'package:smart_learn/features/user/presentation/state_manages/user_bloc/event.dart';
import 'package:smart_learn/features/user/presentation/state_manages/user_bloc/state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UCEUserAdd _add;
  final UCEUserUpdate _update;
  final UCEUserGet _get;

  UserBloc(this._add, this._update, this._get) : super(UserInit()) {
    on<UserEventAdd>(_onAdd);
    on<UserEventUpdate>(_onUpdate);
    on<UserEventGet>(_onGet);
  }

  void _onAdd(UserEventAdd event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await _add(event.params);
    result.fold(
      (failure) => emit(UserError()),
      (sucsess) => emit(UserLoaded(sucsess)),
    );
  }

  void _onUpdate(UserEventUpdate event, Emitter<UserState> emit) async {
    emit(UserUpdating(event.params.user));
    final result = await _update(event.params);
    result.fold(
      (failure) => emit(UserErrorUpdate(event.params.user)),
      (sucsess) => emit(UserLoaded(sucsess)),
    );
  }

  void _onGet(UserEventGet event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await _get(event.params);
    result.fold(
      (failure) => emit(UserError()),
      (sucsess) => emit(UserLoaded(sucsess)),
    );
    emit(UserLoaded(ENTUser.test));
  }
}