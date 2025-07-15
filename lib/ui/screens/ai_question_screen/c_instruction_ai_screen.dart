import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../../../../global.dart';
import 'd_exercise_solution_screen.dart';

class InstructionAIScreen extends StatefulWidget {
  final dynamic data;

  const InstructionAIScreen({super.key, required this.data});

  @override
  State<InstructionAIScreen> createState() => _InstructionAIScreenState();
}

class _InstructionAIScreenState extends State<InstructionAIScreen> {
  String topic = '';
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
                    ExerciseSolutionScreen(topic: topic, instruct: _textController.text, data: widget.data)
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
            Hero(
              tag: 'question',
              child: Container(
                width: MediaQuery.of(context).size.width,
                constraints: const BoxConstraints(maxHeight: 200),
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor(context).withAlpha(20),
                      blurRadius: 6,
                      spreadRadius: 1,
                      offset: const Offset(0, 0.5),
                    ),
                  ],
                ),
                child: Builder(
                  builder: (context) {
                    if (widget.data is String) {
                      ///📝 Text ---------------------------------------------------------------
                      return Material(
                        type: MaterialType.transparency,
                        child: SingleChildScrollView(
                          child: Text(widget.data),
                        ),
                      );
                    } else if (widget.data is CroppedFile) {
                      /// Image -----------------------------------------------------------------
                      return Image.file(
                        File((widget.data as CroppedFile).path),
                        fit: BoxFit.contain,
                      );
                    } else {
                      return const Material(
                        type: MaterialType.transparency,
                        child: Text('Error'),
                      );
                    }
                  },
                ),
              ),
            ),

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
