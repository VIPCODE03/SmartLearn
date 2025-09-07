import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_learn/core/router/app_router_mixin.dart';
import 'package:smart_learn/features/game/games/maze/flame/game.dart';
import 'package:smart_learn/features/game/games/maze/presentation/widgets/direction_pad.dart';
import 'package:smart_learn/features/game/shared/widgets/button_widget.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/ui/widgets/loading_widget.dart';

class SCRMazeGame extends StatelessWidget with AppRouterMixin {
  const SCRMazeGame({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 50),

              Text('Mê cung', style: GoogleFonts.pressStart2p(
                textStyle: TextStyle(
                    fontSize: 35,
                    color: primaryColor(context)
                ),
              )),

              const SizedBox(height: 10),

              _buildButtonSelectLevel(size, 'Dễ', () {
                pushFade(context, const _SCRMazeGame.easy());
              }),
              const SizedBox(height: 10),
              _buildButtonSelectLevel(size, 'Trung bình', () {
                pushFade(context, const _SCRMazeGame.medium());
              }),
              const SizedBox(height: 10),
              _buildButtonSelectLevel(size, 'Khó', () {
                pushFade(context, const _SCRMazeGame.hard());
              }),
              const SizedBox(height: 10),
              _buildButtonSelectLevel(size, 'Cực khó', () {
                pushFade(context, const _SCRMazeGame.extreme());
              }),
              const SizedBox(height: 10),
              _buildButtonSelectLevel(size, 'Master', () {
                pushFade(context, const _SCRMazeGame.master());
              }),
            ],
          ),
        )
      )
    );
  }

  Widget _buildButtonSelectLevel(Size size, String title, VoidCallback onPressed) {
    return WIDButtonGame(
      onPressed: onPressed,
      radius: BorderRadius.circular(8),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        height: 50,
        width: size.width * 0.75,
        child: Text(
          title,
          style: GoogleFonts.pressStart2p(
            textStyle: const TextStyle(fontSize: 16),
          ),
        )
      ),
    );
  }
}

class _SCRMazeGame extends StatefulWidget {
  final String level;

  const _SCRMazeGame.easy() : level = 'easy';
  const _SCRMazeGame.medium() : level = 'medium';
  const _SCRMazeGame.hard() : level = 'hard';
  const _SCRMazeGame.extreme() : level = 'extreme';
  const _SCRMazeGame.master() : level = 'master';

  @override
  State<_SCRMazeGame> createState() => _SCRMazeGameState();
}

class _SCRMazeGameState extends State<_SCRMazeGame> {
  MazeGame? game;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      if(widget.level == 'easy') {
        game = MazeGame.easy();
      } else if(widget.level == 'medium') {
        game = MazeGame.medium();
      }
      else if(widget.level == 'hard') {
        game = MazeGame.hard();
      }
      else if(widget.level == 'extreme') {
        game = MazeGame.expert();
      }
      else {
        game = MazeGame.master();
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(game == null) {
      return const Material(child: Center(child: WdgLoading(),));
    }
    return SafeArea(child: Scaffold(
      body: Row(
        children: [
          Expanded(
            child: GameWidget(
              game: game!,
              overlayBuilderMap: {
                'win': (context, _) => Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.black54,
                    ),
                    child: const Text(
                      '🎉 Bạn đã thoát khỏi mê cung!',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),

                'lose': (context, _) => Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.black54,
                    ),
                    child: const Text(
                      '😭 Bạn đã thua!',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                )
              },
            ),
          ),

          Column(
            children: [
              Expanded(
                  child: ValueListenableBuilder(
                      valueListenable: game!.remainingTime,
                      builder: (context, value, child) {
                        return Container(
                          padding: const EdgeInsets.all(8),
                          child: Text(value.toString(), style: GoogleFonts.pressStart2p(
                            textStyle: const TextStyle(fontSize: 12),
                          )),
                        );
                      }
                  )
              ),

              SizedBox(
                child: DirectionPad(
                  onDirectionChanged: game!.handleDirectionInput,
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
}