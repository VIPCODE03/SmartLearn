import 'package:flutter/material.dart';
import 'package:smart_learn/features/games/math_matrix/domain/entities/matrixsquare_entity.dart';
import 'package:smart_learn/features/games/math_matrix/domain/logics/mathmatrix_generate.dart';
import 'package:smart_learn/global.dart';

class SCRGameMathMatrix extends StatelessWidget {
  const SCRGameMathMatrix({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SCRGameMathMatrix.easy();
  }
}

class _SCRGameMathMatrix extends StatefulWidget {
  final LOGMathMatrixLevel _level;

  const _SCRGameMathMatrix.easy({super.key}) : _level = LOGMathMatrixLevel.easy;

  const _SCRGameMathMatrix.medium({super.key}) : _level = LOGMathMatrixLevel.medium;

  const _SCRGameMathMatrix.hard({super.key}) : _level = LOGMathMatrixLevel.hard;

  @override
  State<_SCRGameMathMatrix> createState() => _SCRGameMathMatrixState();
}

class _SCRGameMathMatrixState extends State<_SCRGameMathMatrix> {
  final logic = LOGMathMatrixGenerate.instance;
  late final Map<String, ENTMatrixSquare?> _map;

  String currentKeySelected = '';
  Map<String, String> answerSelected = {};

  @override
  void initState() {
    super.initState();
    logic.setLevel(widget._level);
    _map = logic.mathGenerate();
  }

  bool _check(String answer) {
    final entity = _map[currentKeySelected];
    return entity!.check(answer);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ma trận 11x11')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final matrixHeight = MediaQuery.of(context).size.height * 0.6;
          final cellSize = matrixHeight / logic.column;

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
                      final entity = _map['$row,$col'];
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
                                color: entity.isHide ? primaryColor(context).withAlpha(100) : primaryColor(context).withAlpha(50),
                                border: isSelected ? Border.all(
                                  color: primaryColor(context),
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
                                : primaryColor(context).withAlpha(150),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_check(value)) {
                                  answerSelected[key] = value;
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
