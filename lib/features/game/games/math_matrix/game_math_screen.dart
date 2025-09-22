import 'package:flutter/material.dart';
import 'package:smart_learn/app/router/app_router_mixin.dart';
import 'package:smart_learn/app/style/appstyle.dart';
import 'package:smart_learn/features/game/games/math_matrix/domain/entities/matrixsquare_entity.dart';
import 'package:smart_learn/features/game/games/math_matrix/domain/logics/mathmaxtrix_generate_dfs.dart';
import 'package:smart_learn/features/game/shared/widgets/button_widget.dart';
import 'package:smart_learn/app/ui/widgets/loading_widget.dart';

class SCRGameMathMatrix extends StatelessWidget with AppRouterMixin {
  const SCRGameMathMatrix({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.style.color;

    return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Math Matrix', style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: color.primaryColor,
            )),

            const SizedBox(height: 20),

            _buildButtonLevel('Dễ', () => pushScale(context, const _SCRGameMathMatrix.easy()), Colors.green),

            const SizedBox(height: 8),

            _buildButtonLevel('Trung bình', () => pushScale(context, const _SCRGameMathMatrix.medium()), Colors.yellow),

            const SizedBox(height: 8),

            _buildButtonLevel('Khó', () => pushScale(context, const _SCRGameMathMatrix.hard()), Colors.red),
          ],
        )
    );
  }

  Widget _buildButtonLevel(String level, VoidCallback onPlay, Color color) {
    return WIDButtonGame(
      onPressed: onPlay,
      color: color.withAlpha(150),
      child: Container(
        alignment: Alignment.center,
        width: 250,
        padding: const EdgeInsets.all(12),
        child: Text(level, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}

class _SCRGameMathMatrix extends StatefulWidget {
  final LOGMathMatrixLevel _level;

  const _SCRGameMathMatrix.easy() : _level = LOGMathMatrixLevel.easy;

  const _SCRGameMathMatrix.medium() : _level = LOGMathMatrixLevel.medium;

  const _SCRGameMathMatrix.hard() : _level = LOGMathMatrixLevel.hard;

  @override
  State<_SCRGameMathMatrix> createState() => _SCRGameMathMatrixState();
}

class _SCRGameMathMatrixState extends State<_SCRGameMathMatrix> {
  final logic = LOGMathMatrixGenerateDFS.instance;
   Map<String, ENTMatrixSquare?>? _map;

  String currentKeySelected = '';
  Map<String, String> answerSelected = {};

  @override
  void initState() {
    super.initState();
    init();
  }

  //- Khởi tạo  ----------------------------------------------------------------
  void init() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      logic.setLevel(widget._level);
      _map = logic.mathGenerate();
    });
  }

  //- Kiểm tra đáp án ----------------------------------------------------------
  bool _check(String answer) {
    final entity = _map![currentKeySelected];
    return entity!.check(answer);
  }
  
  @override
  Widget build(BuildContext context) {
    final color = context.style.color;

    return Scaffold(
      body: _map == null
          ? const Center(child: WdgLoading())
          : LayoutBuilder(
        builder: (context, constraints) {
          final matrixHeight = MediaQuery.of(context).size.height * 0.6;
          final cellSize = (matrixHeight / logic.column).ceilToDouble();

          return Column(
            children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  height: matrixHeight,
                  width: cellSize * logic.row,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: logic.column,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                      childAspectRatio: 1,
                    ),
                    itemCount: logic.column * logic.row,
                    itemBuilder: (context, index) {
                      int row = index ~/ logic.column;
                      int col = index % logic.column;
                      final entity = _map?['$row,$col'];
                      final bool isSelected = currentKeySelected == '$row,$col';

                      if(entity != null) {
                        return GestureDetector(
                          onTap: () {
                            if(entity.isHide) {
                              setState(() {
                                currentKeySelected = '$row,$col';
                              });
                            }
                          },
                          child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: entity.isHide ? color.primaryColor.withAlpha(100) : color.primaryColor.withAlpha(50),
                                border: isSelected ? Border.all(
                                  color: color.primaryColor,
                                  width: 2,
                                ) : null,
                              ),
                              child: FittedBox(
                                child: Text(
                                  entity.isHide
                                      ? answerSelected['$row,$col'] != null ? entity.value : ''
                                      : entity.value,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                    fontWeight: entity.type == 'num' ? FontWeight.normal : FontWeight.bold,
                                  ),
                                )
                              )
                          ),
                        );
                      }
                      return Container(
                        color: Colors.grey.withAlpha(10),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: logic.getAnswers.entries.map((entry) {
                        final key = entry.key;
                        final value = entry.value;
                        final isSelected = answerSelected[key] == value;

                        return Container(
                          constraints: const BoxConstraints(
                            minWidth: 50
                          ),
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.grey.withAlpha(5)
                                : color.primaryColor.withAlpha(150),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_check(value)) {
                                  answerSelected[currentKeySelected] = value;
                                }
                              });
                            },
                            child: Text(
                              value,
                              style: TextStyle(
                                fontSize: 20,
                                color: isSelected ? Colors.grey.withAlpha(50) : null,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                )
            ]
          );
        },
      ),
    );
  }
}
