import 'package:flutter/material.dart';
import 'package:smart_learn/core/router/app_router.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/ui/widgets/app_button_widget.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
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
                child: Icon(Icons.person, color: iconColor(context)),
              ),
              onTap: () => appRouter.user.goUserScreen(context)
          ),

          const Expanded(child: SizedBox()),

          WdgBounceButton(
              child: Icon(Icons.notifications, color: iconColor(context)),
              onTap: () {}
          )
        ],
      ),
    );
  }
}
