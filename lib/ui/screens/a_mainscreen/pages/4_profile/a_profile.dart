import 'package:flutter/material.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/ui/widgets/bouncebutton_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _WdgQuestionExercise(),

        _WdgHorizontal(),

        _WdgMenu(),
      ],
    );
  }
}

class _WdgHorizontal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey.withAlpha(25),
    );
  }
}

///---------------------Question--------------------------
class _WdgQuestionExercise extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(6),
        margin: const EdgeInsets.symmetric(vertical: 50),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Giải bài tập', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),

              const SizedBox(height: 10),

              Row(children: [
                Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey.withAlpha(100)),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.withAlpha(25))
                        ]
                      ),
                      child: const Text('Nhập câu hỏi', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    )
                ),

                const SizedBox(width: 10),

                Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(55),
                      color: primaryColor(context)
                    ),
                    child: const Icon(Icons.camera_alt_outlined, color: Colors.grey,)
                )
              ]),
            ]
        )
    );
  }
}

///----------------------Menu----------------------
class _WdgMenu extends StatelessWidget {
  final _items = [
    _MenuItem(title: 'Trò chuyện', icon: Icons.messenger_outline, onTap: () {}),
    _MenuItem(title: 'Trò chuyện', icon: Icons.messenger_outline, onTap: () {}),
    _MenuItem(title: 'Trò chuyện', icon: Icons.messenger_outline, onTap: () {}),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      runSpacing: 50,
      spacing: 50,
      children: _items.map((item) {
        return BounceButton(
          onTap: item.onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.icon),
              Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  _MenuItem({required this.title, required this.icon, required this.onTap});
}

///---------------------Bài tập gần đây-------------------
class _Exercise extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      margin: const EdgeInsets.symmetric(vertical: 25),
      child: Text('data'),
    );
  }
}