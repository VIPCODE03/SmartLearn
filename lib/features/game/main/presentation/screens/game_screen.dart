import 'package:flutter/material.dart';
import 'package:smart_learn/app/assets/app_assets.dart';
import 'package:smart_learn/app/languages/provider.dart';
import 'package:smart_learn/app/router/app_router_mixin.dart';
import 'package:smart_learn/app/style/appstyle.dart';
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

    final avatars = [
      AppAssets.path.game.avatar.maze,
      AppAssets.path.game.avatar.matrix,
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
            crossAxisCount: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2,
          ),
          itemBuilder: (context, index) {
            return GameCard(
                title: games[index],
                imageUrl: avatars[index],
                onPlay: () => pushSlideUp(context, gameScreens[index])
            );
          },
        ),
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onPlay;

  const GameCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(
          width: 2,
          color: context.style.color.primaryColor,
        ),
        borderRadius: BorderRadius.circular(10)
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[500],
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image, color: Colors.white),
              ),
            ),

            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.grey],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.5, 1.0],
                ),
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Title ----------------------------------------------------
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(width: 8),

                    /// Play Button ----------------------------------------------
                    WIDButtonGame(
                        onPressed: onPlay,
                        radius: BorderRadius.circular(12),
                        color: context.style.color.primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                          child: Text(
                              globalLanguage.play,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                          ),
                        )
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
