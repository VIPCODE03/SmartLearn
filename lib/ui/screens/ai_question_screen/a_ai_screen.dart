import 'package:flutter/material.dart';
import 'package:smart_learn/ui/screens/ai_question_screen/b_question_text_screen.dart';
import 'b_question_picture_screen.dart';

enum TypeQuestion {
  picture,
  text,
}

class AIScreen extends StatelessWidget {
  final TypeQuestion type;
  const AIScreen({super.key, required this.type});

  const AIScreen.camera({super.key}) : type = TypeQuestion.picture;

  const AIScreen.text({super.key}) : type = TypeQuestion.text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI'),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.design_services)
        ),
      ),
      body: _build(context)
    );
  }

  Widget _build(BuildContext context) {
    switch(type) {
      case TypeQuestion.picture:
        return const AICameraScreen();
      case TypeQuestion.text:
        return const AITextQuestionScreen();
    }
  }
}
