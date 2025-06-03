import 'package:flutter/material.dart';
import 'package:smart_learn/global.dart';

import 'c_instruction_ai_screen.dart';

class QuestionTextScreen extends StatefulWidget {
  const QuestionTextScreen({super.key});

  @override
  State<QuestionTextScreen> createState() => _QuestionTextScreenState();
}

class _QuestionTextScreenState extends State<QuestionTextScreen> {
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ///-  Button tiếp ---------------------------------------------------
            GestureDetector(
              onTap: () {
                hideKeyboardAndRemoveFocus(context);
                navigateToNextScreen(
                    context, InstructionAIScreen(data: _textController.text.trim()),
                    offsetBegin: const Offset(0, 0));
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
                      color: primaryColor(context).withAlpha(20),
                      blurRadius: 6,
                      spreadRadius: 1,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Text(
                  globalLanguage.next,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
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
              ),
            )),
          ],
        ),
      ),
    );
  }
}
