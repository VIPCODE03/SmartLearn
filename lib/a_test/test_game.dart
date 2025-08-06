import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: GameWithControls(),
      ),
    ),
  );
}

class GameWithControls extends StatefulWidget {
  @override
  State<GameWithControls> createState() => _GameWithControlsState();
}

class _GameWithControlsState extends State<GameWithControls> {
  final myGame = MyGame();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GameWidget(game: myGame),
        Positioned(
          bottom: 40,
          left: 100,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_left),
                onPressed: () => myGame.movePlayer(dx: -20, dy: 0),
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_upward),
                    onPressed: () => myGame.movePlayer(dx: 0, dy: -20),
                  ),
                  SizedBox(height: 10),
                  IconButton(
                    icon: Icon(Icons.arrow_downward),
                    onPressed: () => myGame.movePlayer(dx: 0, dy: 20),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.arrow_right),
                onPressed: () => myGame.movePlayer(dx: 20, dy: 0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MyGame extends FlameGame {
  late Player player;
  late Obstacle wall;

  @override
  Future<void> onLoad() async {
    // Thêm player
    player = Player()
      ..position = Vector2(100, 100)
      ..anchor = Anchor.center;
    add(player);

    // Thêm obstacle
    wall = Obstacle()
      ..position = Vector2(160, 100)
      ..anchor = Anchor.center;
    add(wall);
  }

  void movePlayer({required double dx, required double dy}) {
    final newPos = player.position + Vector2(dx, dy);

    // Kiểm tra va chạm với obstacle
    if (!player.collidesWith(wall, newPos)) {
      player.position = newPos;
    }
  }
}

class Player extends PositionComponent {
  final double radius = 20;

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.blue;
    canvas.drawCircle(Offset.zero, radius, paint);
  }

  bool collidesWith(Obstacle obstacle, Vector2 newPosition) {
    final obstacleRect = obstacle.toRect();
    final playerRect = Rect.fromCircle(center: newPosition.toOffset(), radius: radius);
    return obstacleRect.overlaps(playerRect);
  }

  @override
  void update(double dt) {}
}

class Obstacle extends PositionComponent {
  final double width = 40;
  final double height = 40;

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.red;
    canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: width, height: height), paint);
  }

  Rect toRect() {
    final topLeft = position - Vector2(width / 2, height / 2);
    return Rect.fromLTWH(topLeft.x, topLeft.y, width, height);
  }

  @override
  void update(double dt) {}
}
