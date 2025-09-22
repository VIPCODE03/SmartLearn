import 'package:flutter/material.dart';
import 'package:smart_learn/app/languages/provider.dart';
import 'package:smart_learn/app/style/appstyle.dart';
import 'package:smart_learn/screen/smartlearn/mainscreen/pages/1_home/a_home_page.dart';
import 'package:smart_learn/screen/smartlearn/mainscreen/pages/2_subject/a_subject_page.dart';
import 'package:smart_learn/screen/smartlearn/mainscreen/pages/3_schedule/a_schedule.dart';
import 'package:smart_learn/screen/smartlearn/mainscreen/pages/4_profile/a_profile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selected = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const SubjectPage(),
    const SchedulePage(),
    const PS(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      body: _pages[_selected],

      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              blurRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selected,
            selectedItemColor: context.style.color.primaryColor,
            unselectedItemColor: Colors.grey[600],
            elevation: 0,

            onTap: (index) {
              setState(() {
                _selected = index;
              });
            },

            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                label: globalLanguage.tab1,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.book_outlined),
                label: globalLanguage.tab2,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.calendar_today_outlined),
                label: globalLanguage.tab3,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings_outlined),
                label: globalLanguage.tab4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
