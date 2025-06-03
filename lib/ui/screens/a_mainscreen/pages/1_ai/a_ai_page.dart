import 'package:flutter/material.dart';
import 'package:smart_learn/global.dart';
import 'b_question_picture_screen.dart';
import 'b_question_text_screen.dart';

class AIPage extends StatelessWidget {
  const AIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trợ lý AI'),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        double heightPath = MediaQuery.of(context).size.height / 8;
        double widthPath = MediaQuery.of(context).size.width / 8;
        bool isLandscape = orientation == Orientation.landscape;

        return Center(
          child: Wrap(
            spacing: 50,
            runSpacing: 50,
            alignment: WrapAlignment.center,
            children: [

              const SizedBox(width: 10),

              ///-  Ô hỏi bằng hình ảnh -------------------------------------------
              SizedBox(
                height: isLandscape ? heightPath * 4 : heightPath * 2,
                width: isLandscape ? widthPath * 2 : widthPath * 4,
                child: _Item(
                    title: '📷 ${globalLanguage.picture}',
                    description: globalLanguage.pictureDesc,
                    color: Colors.orangeAccent,
                    onTap: () => navigateToNextScreen(context, const CameraScreen())
                ),
              ),

              ///-  Ô hỏi bằng văn bản  ---------------------------------------------
              SizedBox(
                height: isLandscape ? heightPath * 4 : heightPath * 2,
                width: isLandscape ? widthPath * 2 : widthPath * 4,
                child: _Item(
                    title: '📝 ${globalLanguage.text}',
                    description: globalLanguage.textDesc,
                    color: Colors.deepOrangeAccent,
                    onTap: () => navigateToNextScreen(context, const QuestionTextScreen())
                ),
              ),

              ///-  Lịch sử  ---------------------------------------------------------
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.history),

                    Text(globalLanguage.history)
                  ],
                ),
              ),
            ],
          ),
        );
      })
    );
  }
}

///-  Item chọn kiểu hỏi  -----------------------------------------------------------
class _Item extends StatelessWidget {
  final String title;
  final String description;
  final Color color;
  final VoidCallback  onTap;

  const _Item({required this.title, required this.description, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color.withAlpha(100),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(66),
              blurRadius: 6,
              spreadRadius: 2,
              offset: const Offset(1.5, 2.5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            Expanded(child: Text(description, style: const TextStyle(fontSize: 14, color: Colors.grey))),

            const Align(
              alignment: Alignment.bottomRight,
              child: Icon(Icons.keyboard_double_arrow_right),
            )
          ],
        )
      )
    );
  }
}