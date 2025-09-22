import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_learn/app/style/appstyle.dart';
import 'package:smart_learn/core/di/injection.dart';
import 'package:smart_learn/features/user/domain/entities/user_entity.dart';
import 'package:smart_learn/features/user/domain/parameters/user_params.dart';
import 'package:smart_learn/features/user/presentation/state_manages/user_bloc/bloc.dart';
import 'package:smart_learn/features/user/presentation/state_manages/user_bloc/event.dart';
import 'package:smart_learn/features/user/presentation/state_manages/user_bloc/state.dart';
import 'package:smart_learn/app/ui/widgets/divider_widget.dart';
import 'package:smart_learn/app/ui/widgets/loading_widget.dart';

class SCRUser extends StatefulWidget {
  const SCRUser({super.key});

  @override
  State<StatefulWidget> createState() => _SCRUserState();
}

class _SCRUserState extends State<SCRUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.style.color.primaryColor.withAlpha(200),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.design_services)
        ),
      ),
      body: BlocProvider<UserBloc>(
          create: (context) => UserBloc(getIt(), getIt(), getIt())..add(UserEventGet(PARUserGet())),
          child: BlocListener<UserBloc, UserState>(
            listener: (context, state) {},
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
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
                  return UserProfileScreen(user: user);
                }
                return const SizedBox();
              },
            ),
          )
      )
    );
  }
}

class UserProfileScreen extends StatelessWidget {
  final ENTUser user;
  const UserProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        /// HEADER + AVATAR   -----------------------------------------------------
        SizedBox(
          height: 150 + 40,
          child: Stack(
            children: [
              SizedBox(
                height: 150,
                width: double.infinity,
                child: CustomPaint(
                  painter: _HeaderBackground(
                    baseColor: context.style.color.primaryColor,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 25,
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: user.avatar != null
                        ? NetworkImage(user.avatar!)
                        : const AssetImage('assets/images/avatar_placeholder.png') as ImageProvider,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        const WdgDivider(height: 2),

        ///- THÔNG TIN  --------------------------------------------------------
        _Item(
          icon: Icons.person,
          title: 'Họ và tên',
          value: user.name,
          top: false,
        ),

        _Item(
          icon: Icons.school,
          title: 'Lớp',
          value: user.grade,
        ),

        _Item(
          icon: Icons.cake,
          title: 'Tuổi',
          value: '${user.age}',
        ),

        if (user.email != null && user.email!.isNotEmpty)
          _Item(
            icon: Icons.email,
            title: 'Email',
            value: user.email!,
          ),

        if (user.bio != null && user.bio!.isNotEmpty)
          _Item(
            icon: Icons.info,
            title: 'Tiểu sử',
            value: user.bio!,
          ),

        if (user.hobbies.isNotEmpty)
          _Item(
            icon: Icons.star,
            title: 'Sở thích',
            value: user.hobbies,
            bottom: false,
          ),
      ],
    );
  }
}

///-  ITEM THÔNG TIN  ----------------------------------------------------------
class _Item extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool top;
  final bool bottom;

  const _Item({
    required this.icon,
    required this.title,
    required this.value,
    this.top = true,
    this.bottom = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
        children: [
          SizedBox(
            child: Column(
              children: [
                WdgDivider(width: 5, height: 20, color: top ? null : Colors.transparent),
                SizedBox(
                  height: 50,
                  child: CircleAvatar(
                      radius: 25,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(icon),
                      )
                  ),
                ),
                WdgDivider(width: 5, height: 20, color: bottom ? null : Colors.transparent),
              ],
            ),
          ),

          const WdgDivider(height: 3, width: 30),

          Expanded(
              child: Container(
                  constraints: const BoxConstraints(
                      maxHeight: 90,
                      minHeight: 40
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 25,
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: context.style.color.primaryColor.withAlpha(25)
                        ),
                        child: Text(
                          value,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  )
              )
          )
        ],
      )
    );
  }
}

///-  HEADER  ------------------------------------------------------------------
class _HeaderBackground extends CustomPainter {
  final Color baseColor;

  _HeaderBackground({required this.baseColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    paint.color = baseColor.withAlpha(200);
    final backgroundPath = Path()
      ..lineTo(0, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.25, size.height, size.width * 0.5, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.6, size.width, size.height * 0.85)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(backgroundPath, paint);

    paint.color = Colors.white.withAlpha(50);
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.3), 30, paint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.5), 40, paint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.2), 20, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
