import 'package:flutter/material.dart';
import 'package:smart_learn/ui/widgets/app_button_widget.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          WdgBounceButton(
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(50),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(Icons.person),
              ),
              onTap: () {}
          ),

          const Expanded(child: SizedBox()),

          WdgBounceButton(
              child: const Icon(Icons.notifications),
              onTap: () {}
          )
        ],
      ),
    );
  }
}
