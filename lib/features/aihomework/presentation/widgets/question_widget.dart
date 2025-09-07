import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../../../global.dart';

class WIDQuestionAI extends StatelessWidget {
  final String textQuestion;
  final Uint8List? imageQuestion;
  const WIDQuestionAI({super.key, required this.textQuestion, this.imageQuestion});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Hero(
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
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(imageQuestion != null)
                    SizedBox(
                      height: 100,
                      child: Image.memory(imageQuestion!),
                    ),

                  SingleChildScrollView(child: Text(textQuestion)),
                ],
              );
            },
          ),
        ),
      )
    );


  }
}