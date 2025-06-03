import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/ui/screens/a_mainscreen/pages/1_ai/a_ai_page.dart';
import 'package:smart_learn/ui/screens/a_mainscreen/pages/2_subject/a_subject_page.dart';
import 'package:smart_learn/ui/screens/a_mainscreen/pages/2_subject/a_subjects.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selected = 0;

  final List<Widget> _pages = [
    const AIPage(),
    const SubjectPage(),
    const PS(),
    const Center(child: Text('Hồ sơ', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: _pages[_selected],
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.white10,
        style: TabStyle.flip,
        color: Colors.grey[600],
        activeColor: Colors.green,
        elevation: 6,
        items: [
          TabItem(icon: Icons.auto_awesome, title: globalLanguage.tab1),
          TabItem(icon: Icons.book, title: globalLanguage.tab2),
          TabItem(icon: Icons.schedule, title: globalLanguage.tab3),
          TabItem(icon: Icons.account_circle_outlined, title: globalLanguage.tab4),
        ],
        initialActiveIndex: _selected,
        onTap: (int index) {
          setState(() {
            _selected = index;
          });
        },
      ),
    );
  }
}
