import 'package:flutter/material.dart';
import 'package:smart_learn/app/style/appstyle.dart';
import 'package:smart_learn/app/ui/widgets/app_button_widget.dart';
import 'package:smart_learn/core/link/routers/app_router.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.style.color;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          WdgBounceButton(
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(20),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(Icons.person, color: color.iconColor),
              ),
              onTap: () => appRouter.user.goUserScreen(context)
          ),

          const Expanded(child: SizedBox()),

          WdgBounceButton(
              child: Icon(Icons.notifications, color: color.iconColor),
              onTap: () {}
          )
        ],
      ),
    );
  }
}
