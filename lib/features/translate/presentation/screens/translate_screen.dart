import 'package:flutter/material.dart';
import 'package:smart_learn/features/translate/domain/entities/language_entity.dart';
import 'package:smart_learn/features/translate/presentation/screens/translated_screen.dart';
import 'package:smart_learn/ui/widgets/app_button_widget.dart';
import 'package:smart_learn/ui/widgets/textfeild_widget.dart';
import '../../../../../global.dart';

class SCRTranslation extends StatefulWidget {
  const SCRTranslation({super.key});

  @override
  State<StatefulWidget> createState() => _SCRTranslationState();
}

class _SCRTranslationState extends State<SCRTranslation> {
  final TextEditingController _inputController = TextEditingController();

  int indexExpand = 0;
  ENTLanguage _targetLanguage = ENTLanguage.all.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.history, color: Colors.grey)
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Expanded(
                    child: Center(child: Text('Phát hiện ngôn ngữ', style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w500)))
                ),

                const SizedBox(width: 5),

                const Icon(Icons.arrow_forward),

                const SizedBox(width: 5),

                Expanded(
                    child: Center(child: WdgBounceButton(
                        child: Text(_targetLanguage.name, style: TextStyle(color: primaryColor(context), fontSize: 18, fontWeight: FontWeight.w500)),
                        onTap: () {
                          _showBottomSheetSelectLanguage(context, _targetLanguage, (i) {
                            setState(() {
                              _targetLanguage = i;
                            });
                          });
                        }
                    ))
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withAlpha(10),
                        offset: const Offset(0, 2)
                    )
                  ],
                ),
                child: SingleChildScrollView(
                  child: TextField(
                    controller: _inputController,
                    decoration: const InputDecoration(
                      hintText: 'Nhập văn bản cần dịch',
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                  ),
                )
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(_inputController.text.isNotEmpty) {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) =>
                    SCRTranslated(
                        originalText: _inputController.text,
                        codeTargetLanguage: _targetLanguage.name
                    )
            ));
          }
        },
        backgroundColor: primaryColor(context),
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(Icons.arrow_forward),
      ),

    );
  }
}

///--  Dialog chọn ngôn ngữ   --------------------------------------------------------
void _showBottomSheetSelectLanguage(BuildContext context, ENTLanguage current, Function(ENTLanguage) onSelect) {
  String search = "";
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
              height: MediaQuery.of(context).size.height / 1.5,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Chọn ngôn ngữ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withAlpha(10),
                            offset: const Offset(0, 2)
                        )
                      ],
                    ),
                    child: WdgTextFeildCustom(
                      hintText: 'Tìm kiếm',
                      onChanged: (value) {
                        setState(() {
                          search = value ?? '';
                        });
                      },
                    ),
                  ),

                  Expanded(
                      child: ListView(
                        children: ENTLanguage.all.map((language) {
                          if(search.isEmpty || language.name.toLowerCase().contains(search.toLowerCase())) {
                            return TextButton(
                                onPressed: () {
                                  onSelect(language);
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Text(language.name)
                                    ),

                                    if(current == language)
                                      const Icon(Icons.check),
                                  ],
                                )
                            );
                          }
                          return const SizedBox.shrink();
                        }).toList(),
                      )
                  )
                ],
              )
          );
        });
      }
  );
}