import 'package:flutter/material.dart';
import 'package:smart_learn/features/aihomework/presentation/screens/b_question_text_screen.dart';
import 'b_question_picture_screen.dart';

class SCRAIHomeWork extends StatelessWidget {
  final int type;

  const SCRAIHomeWork.camera({super.key}) : type = 1;

  const SCRAIHomeWork.text({super.key}) : type = 2;

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
      case 1:
        return const SCRAICamera();
      case 2:
        return const SCRAIText();
      default:
        throw Exception();
    }
  }
}
