import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:smart_learn/features/games/maze/flame/game.dart';
import 'package:smart_learn/features/games/maze/presentation/widgets/direction_pad.dart';

void main() {
  runApp(MazeApp());
}

class MazeApp extends StatelessWidget {
  final game = MazeGame();
  MazeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            Expanded(child: Center(child:  GameWidget(
              game: game,
              overlayBuilderMap: {
                'win': (context, _) => Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      '🎉 Bạn đã thoát khỏi mê cung!',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              },
            ),),),

            SizedBox(
              height: 150,
              child: DirectionPad(
                onDirectionChanged: game.handleDirectionInput,
              ),
            )
          ],
        ),
      ),
    );
  }
}
