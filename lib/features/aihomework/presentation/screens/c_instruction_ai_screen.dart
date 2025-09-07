import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:smart_learn/core/router/app_router_mixin.dart';
import 'package:smart_learn/features/aihomework/presentation/widgets/question_widget.dart';

import '../../../../../global.dart';
import 'd_exercise_solution_screen.dart';

class SCRAIInstruction extends StatefulWidget {
  final String textQuestion;
  final Uint8List? image;

  const SCRAIInstruction({
    super.key,
    required this.textQuestion,
    this.image
  });

  @override
  State<SCRAIInstruction> createState() => _SCRAIInstructionState();
}

class _SCRAIInstructionState extends State<SCRAIInstruction> with AppRouterMixin {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Padding(padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () {
                navigateToNextScreen(
                    context,
                    SCRExerciseSolution(
                      instruct: _textController.text,
                      textQuestion: widget.textQuestion,
                      image: widget.image,
                    )
                );
              },
              child: Text(globalLanguage.next,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor(context)),
              ),
            )
          )
        ],
      ),
      body: Padding(padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            ///-  Câu hỏi -------------------------------------------------------
            WIDQuestionAI(textQuestion: widget.textQuestion, imageQuestion: widget.image),

            ///-  Chọn môn học  --------------------------------------------------
            const Align(alignment: Alignment.center,
                child: Text('Chọn 1 môn học',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                )
            ),

            _HorizontalItemBar(
              itemList: const ['Chung', 'Toán học', 'Văn học', 'Vật lý', 'Lập trình di động'],
              onItemPressed: (String item) {

              },
            ),

             Container(
               height: 0.5,
               width: MediaQuery.of(context).size.width,
               margin: const EdgeInsets.symmetric(vertical: 10),
               color: Colors.grey.withAlpha(50),
            ),

            ///-  Hướng dẫn giải  -----------------------------------------------
            const Align(alignment: Alignment.center,
                child: Text('Hướng dẫn giải',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                )
            ),

            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor(context).withAlpha(20),
                    blurRadius: 6,
                    spreadRadius: 1,
                    offset: const Offset(0, 0.5),
                  ),
                ],
              ),
              child: TextField(
                controller: _textController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: globalLanguage.hintQuestion,
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}

///-  Item chọn môn học --------------------------------------------------------
class _HorizontalItemBar extends StatefulWidget {
  final List<String> itemList;
  final Function(String ) onItemPressed;

  const _HorizontalItemBar({
    required this.itemList,
    required this.onItemPressed,
  });

  @override
  State<_HorizontalItemBar> createState() => _HorizontalItemBarState();
}

class _HorizontalItemBarState extends State<_HorizontalItemBar> {
  int indexSelected = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      height: 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: primaryColor(context), width: 0.5),
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Center(
              child: Text(widget.itemList[indexSelected], 
                style: TextStyle(color: primaryColor(context), fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
            width: 1000,
            height: 1,
            color: Colors.grey.withAlpha(100),
          ),

          Expanded(
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    ...widget.itemList.map((item) {
                      final isSelected = indexSelected == widget.itemList.indexOf(item);
                      return Container(
                        padding: isSelected ? null : const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              indexSelected = widget.itemList.indexOf(item);
                            });
                            widget.onItemPressed(item);
                          },
                          child: Container(
                            height: isSelected ? 0 : null,
                            width: isSelected ? 0 : null,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 0.25),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                            child: Center(
                              child: Text(item),
                            ),
                          ),
                        )
                    );}),
                  ])
              ),
          )
        ],
      ),
    );
  }
}
