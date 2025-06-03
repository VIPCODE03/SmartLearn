import 'package:flutter/material.dart';
import 'package:performer/main.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/performers/action_unit/gemini_action.dart';
import 'package:smart_learn/performers/data_state/gemini_state.dart';
import 'package:smart_learn/performers/performer/gemini_conductor.dart';
import 'package:smart_learn/ui/widgets/bouncebutton_widget.dart';

class WdgTranslation extends StatefulWidget {
  const WdgTranslation({super.key});

  @override
  State<WdgTranslation> createState() => _WdgTranslationState();
}

class _WdgTranslationState extends State<WdgTranslation> {
  final PageController _pageController = PageController();
  final TextEditingController _inputController = TextEditingController();

  String _targetLang = 'vi';
  String _translatedText = '';
  bool next = false;

  final List<Map<String, String>> _languages = [
    {'code': 'vi', 'label': 'Tiếng Việt'},
    {'code': 'en', 'label': 'English'},
    {'code': 'ja', 'label': 'Japanese'},
    {'code': 'fr', 'label': 'French'},
    {'code': 'zh', 'label': 'Chinese'},
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: SizedBox(
        height: 400,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildInputPage(),
            _buildResultPage(),
          ],
        ),
      ),
    );
  }

  //--------------- Chuyển page dịch  ----------------------
  void _nextPageTranslate(String translated) {
    setState(() {
      next = false;
      _translatedText = translated;
    });
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  //------------------- Quay lại  ----------------------------
  void _goBack() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  ///---------------------- Page 1 --------------------------
  Widget _buildInputPage() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Stack(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.design_services)),
            ),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Dịch thuật',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ]),

          Align(
            alignment: Alignment.topRight,
            child: PerformerProvider<GeminiConductor>(
              create: () => GeminiConductor(),
              child: ConductorBuilder<GeminiConductor>(builder: (context, performer) {
                final state = performer.current;
                if (state.state == GemState.done && next) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && next) {
                      _nextPageTranslate(state.answers);
                    }
                  });
                }

                return BounceButton(
                  onTap: _inputController.text.trim().isEmpty || state.state == GemState.progress
                      ? () {}
                      : () {
                    setState(() {
                      next = true;
                    });
                    performer.add(
                      GemTranslate(
                        translate: _inputController.text.trim(),
                        language: _targetLang,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: _inputController.text.trim().isEmpty || state.state == GemState.progress
                          ? Colors.grey
                          : primaryColor(context),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: state.state == GemState.progress ? const SizedBox(
                      width: 10,
                      height: 10,
                      child: CircularProgressIndicator(strokeWidth: 1),
                    )
                        : const Text('Dịch', style: TextStyle(color: Colors.white)),
                  ),
                );
              }),
            )
          ),

          const SizedBox(height: 10),

          TextField(
            controller: _inputController,
            maxLines: 3,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Nhập văn bản cần dịch...',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Dịch sang:'),
              const SizedBox(width: 12),
              DropdownButton<String>(
                value: _targetLang,
                items: _languages.map((lang) {
                  return DropdownMenuItem<String>(
                    value: lang['code'],
                    child: Text(lang['label']!),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _targetLang = value;
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }


  ///---------------------- Page 2 ---------------------------
  Widget _buildResultPage() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Stack(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(onPressed: _goBack, icon: const Icon(Icons.arrow_back)),
            ),

            const Align(
              alignment: Alignment.center,
              child: Text(
                'Kết quả dịch',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ]),

          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                _translatedText,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
