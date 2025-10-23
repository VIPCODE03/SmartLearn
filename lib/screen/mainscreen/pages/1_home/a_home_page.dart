import 'package:flutter/material.dart';
import 'package:smart_learn/app/ui/widgets/divider_widget.dart';
import 'package:smart_learn/screen/mainscreen/pages/1_home/a_w_1_appbar.dart';
import 'package:smart_learn/screen/mainscreen/pages/1_home/a_w_2_ai.dart';
import 'package:smart_learn/screen/mainscreen/pages/1_home/a_w_3_utilities_widget.dart';
import 'package:smart_learn/screen/mainscreen/pages/1_home/a_w_focus.dart';
import 'package:smart_learn/screen/mainscreen/pages/1_home/a_w_game.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      children: const [
        HomeAppBar(),
        SizedBox(height: 30),

        HomeAI(),
        SizedBox(height: 30),
        WdgDivider(),

        SizedBox(height: 10),
        HomeUtilities(),
        SizedBox(height: 10),
        WdgDivider(),

        HomeFocusStatus(),
        SizedBox(height: 10),
        WdgDivider(),

        SizedBox(height: 10),
        HomeGame(),
        SizedBox(height: 10),
      ],
    );
  }
}