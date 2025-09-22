import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_learn/core/di/injection.dart';
import 'package:smart_learn/features/user/domain/parameters/user_params.dart';
import 'package:smart_learn/features/user/presentation/state_manages/user_bloc/bloc.dart';
import 'package:smart_learn/features/user/presentation/state_manages/user_bloc/event.dart';
import 'package:smart_learn/features/user/presentation/state_manages/user_bloc/state.dart';
import 'package:smart_learn/app/ui/widgets/loading_widget.dart';

typedef UserInfoBuilder = Widget Function(String name, int age, String email, String bio, String grade, String hobbies);

class WIDUserInfo extends StatelessWidget {
  final UserInfoBuilder builder;
  const WIDUserInfo({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
      create: (context) => UserBloc(getIt(), getIt(), getIt())..add(UserEventGet(PARUserGet())),
      child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
        if(state is UserNoData) {
          if(state is UserLoading) {
            return const Center(child: WdgLoading());
          }
          else if(state is UserError) {
            return const Center(child: Text('Lỗi'));
          }
        }
        else if(state is UserHasData) {
          final user = state.user;
          return builder(user.name, user.age, user.email ?? '', user.bio ?? '', user.grade, user.hobbies);
        }
        return const SizedBox();
      })
    );
  }
}