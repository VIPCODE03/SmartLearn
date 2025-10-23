import 'package:flutter/material.dart';
import 'package:smart_learn/app/languages/provider.dart';
import 'package:smart_learn/core/feature_widgets/app_widget_provider.dart';

class HomeGame extends StatelessWidget {
  const HomeGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          globalLanguage.game,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        SizedBox(
          width: 300,
          child: Text(
            globalLanguage.descGame,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              height: 1.4,
            ),
          ),
        ),

        const SizedBox(height: 20),

        appWidget.game.buttonGame(context),
      ],
    );
  }
}
