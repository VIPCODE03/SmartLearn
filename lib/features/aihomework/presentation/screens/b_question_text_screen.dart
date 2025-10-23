import 'package:flutter/material.dart';
import 'package:smart_learn/app/languages/provider.dart';
import 'package:smart_learn/app/router/app_router_mixin.dart';
import 'package:smart_learn/app/style/appstyle.dart';
import 'package:smart_learn/features/aihomework/presentation/screens/d_exercise_solution_screen.dart';
import 'package:smart_learn/utils/keybroad_util.dart';

class SCRAIText extends StatefulWidget {
  const SCRAIText({super.key});

  @override
  State<SCRAIText> createState() => _SCRAITextState();
}

class _SCRAITextState extends State<SCRAIText> with AppRouterMixin {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ///-  Button tiếp ---------------------------------------------------
          GestureDetector(
            onTap: () {
              hideKeyboardAndRemoveFocus(context);
              pushSlideLeft(context, SCRExerciseSolution(textQuestion: _textController.text.trim()));
            },
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: context.style.color.primaryColor.withAlpha(20),
                    blurRadius: 6,
                    spreadRadius: 1,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Text(
                globalLanguage.next,
                style: TextStyle(
                    color: context.style.color.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ),

          ///-  Ô nhập văn bản  ------------------------------------------------
          Expanded(child: Hero(
            tag: 'question',
            child: Material(
                type: MaterialType.transparency,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: context.style.color.primaryColor.withAlpha(20),
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
            ),
          )),
        ],
      ),
    );
  }
}
