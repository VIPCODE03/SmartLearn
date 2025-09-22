import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_learn/app/router/app_router_mixin.dart';
import 'package:smart_learn/features/game/games/math_matrix/game_math_screen.dart';
import 'package:smart_learn/features/game/games/maze/presentation/maze_game_screen.dart';
import 'package:smart_learn/features/game/shared/widgets/button_widget.dart';

class SCRGame extends StatelessWidget with AppRouterMixin {
  const SCRGame({super.key});

  @override
  Widget build(BuildContext context) {
    final games = [
      'Maze',
      'Math Matrix'
    ];

    final gameScreens = [
      const SCRMazeGame(),
      const SCRGameMathMatrix()
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Games')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: games.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            return GameCard(title: games[index], onPlay: () {
              pushSlideUp(context, gameScreens[index]);
            });
          },
        ),
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String title;
  final VoidCallback onPlay;

  const GameCard({
    super.key,
    required this.title,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.grey
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(title),

        const SizedBox(height: 8),
        WIDButtonGame(
          onPressed: onPlay,
          radius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text('Play',
              style: GoogleFonts.pressStart2p(
              textStyle: const TextStyle(fontSize: 16),
            ),),
          )
        ),
      ]
    );
  }
}
